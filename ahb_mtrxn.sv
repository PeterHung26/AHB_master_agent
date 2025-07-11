import ahb_types_pkg::*;
`include "uvm_macros.svh"

class ahb_mtrxn extends uvm_sequence_item;
    // This file defines the AHB manager transaction class
    rand bit reset;

    // Address and control signals
    rand bit [31:0] addr [];
    rand bit [31:0] wdata [];
    rand size_t trans_size;
    rand rw_t rw;
    rand burst_t burst;
    rand transfer_t transfer[];

    // Resonse signals from the subordinate
    resp_t resp;
    bit ready;
    bit [31:0] rdata [];

    // How many cycles manager will be busy
    rand bit busy[];
    rand int num_of_busy;
    
    constraint addr_size {
        if(burst == SINGLE)
            addr.size() == 1;
        //  Manager must not attempt to start an incrementing burst that crosses a 1KB address boundary
        else if(burst == INCR)
            addr.size() < 1024/(2**trans_size); 
        else if(burst == INCR4 || burst == WRAP4)
            addr.size() == 4;
        else if(burst == INCR8 || burst == WRAP8)
            addr.size() == 8;
        else if(burst == INCR16 || burst == WRAP16)
            addr.size() == 16;
    }
    constraint min_addr_size{
        addr.size() >= 1;
    }
    constraint wdata_size {
        wdata.size() == addr.size();
    }
    //  Manager must not attempt to start an incrementing burst that crosses a 1KB address boundary
    constraint 1KB_boundary{
        if(burst == INCR)
            addr[0][10:0] < (1024 - addr.size() * (2**trans_size));
        else if(burst == INCR4 || burst == WRAP4)
            addr[0][10:0] < (1024 - 4 * (2**trans_size));
        else if(burst == INCR8 || burst == WRAP8)
            addr[0][10:0] < (1024 - 8 * (2**trans_size));
        else if(burst == INCR16 || burst == WRAP16)
            addr[0][10:0] < (1024 - 16 * (2**trans_size));
    }
    constraint addr_alignment{
        if(trans_size == HALFWORD)
            foreach (addr[i])
                addr[i][0] == 0;
        else if(trans_size == WORD)
            foreach (addr[i])
                addr[i][1:0] == 0;
    }
    constraint addr_incr_val{
        if(burst != SINGLE) begin
            if(burst == INCR || burst == INCR4 || burst == INCR8 || burst == INCR16) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i] == addr[i-1] + 2**trans_size;
                    end
                end
            end
        end
    }
    constraint addr_wrap_val{
        if(burst == WRAP4) begin
            if(trans_size == BYTE) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][1:0] == addr[i-1][1:0] + 1;
                        addr[i][31:2] == addr[i-1][31:2];
                    end
                end
            end
            else if(trans_size == HALFWORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][2:0] == addr[i-1][2:0] + 2;
                        addr[i][31:3] == addr[i-1][31:3];
                    end
                end
            end
            else if(trans_size == WORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][3:0] == addr[i-1][3:0] + 4;
                        addr[i][31:4] == addr[i-1][31:4];
                    end
                end
            end
        end
        else if(burst == WRAP8) begin
            if(trans_size == BYTE) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][2:0] == addr[i-1][2:0] + 1;
                        addr[i][31:3] == addr[i-1][31:3];
                    end
                end
            end
            else if(trans_size == HALFWORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][3:0] == addr[i-1][3:0] + 2;
                        addr[i][31:4] == addr[i-1][31:4];
                    end
                end
            end
            else if(trans_size == WORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][4:0] == addr[i-1][4:0] + 4;
                        addr[i][31:5] == addr[i-1][31:5];
                    end
                end
            end
        end
        else if(burst == WRAP16) begin
            if(trans_size == BYTE) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][3:0] == addr[i-1][3:0] + 1;
                        addr[i][31:4] == addr[i-1][31:4];
                    end
                end
            end
            else if(trans_size == HALFWORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][4:0] == addr[i-1][4:0] + 2;
                        addr[i][31:5] == addr[i-1][31:5];
                    end
                end
            end
            else if(trans_size == WORD) begin
                foreach (addr[i]) begin
                    if(i > 0) begin
                        addr[i][5:0] == addr[i-1][5:0] + 4;
                        addr[i][31:6] == addr[i-1][31:6];
                    end
                end
            end
        end
    }
    constraint trans_size_val{
        trans_size inside {BYTE, HALFWORD, WORD};
    }
    constraint trans_type{
        if(burst == SINGLE) begin
            transfer.size() == 1;
            transfer[0] == NONSEQ;
        end
        else begin
            transfer.size() == num_of_busy + addr.size();
            foreach (transfer[i]) begin
                if(i > 0) begin
                    if(busy[i] == 1)
                        transfer[i] == BUSY;
                    else
                        transfer[i] == SEQ;
                end
                else
                    transfer[i] == NONSEQ;
            end
        end
    }
    constraint num_of_busy_val{
        num_of_busy >= 0;
        num_of_busy <= addr.size();
    }
    constraint busy_position{
        busy.size() == transfer.size();
        int one = 0
        foreach(busy[i]) begin
            if(busy[i] == 1)
                one++;
        end
        one == num_of_busy;
    }

    `uvm_object_utils_begin(ahb_mtrxn)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_array_int(addr, UVM_ALL_ON)
        `uvm_field_array_int(wdata, UVM_ALL_ON)
        `uvm_field_enum(size_t, trans_size, UVM_ALL_ON)
        `uvm_field_enum(rw_t, rw, UVM_ALL_ON)
        `uvm_field_enum(burst_t, burst, UVM_ALL_ON)
        `uvm_field_array_enum(transfer_t, transfer, UVM_ALL_ON)
        `uvm_field_enum(resp_t, resp, UVM_ALL_ON)
        `uvm_field_int(ready, UVM_ALL_ON)
        `uvm_field_array_int(rdata, UVM_ALL_ON)
        `uvm_field_array_int(busy, UVM_ALL_ON)
        `uvm_field_int(num_of_busy, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "ahb_mtrxn");
        super.new(name);
    endfunction: new
endclass: ahb_mtrxn