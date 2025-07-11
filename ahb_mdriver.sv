`include "uvm_macro.svh"

class ahb_mdriver extends uvm_driver #(ahb_mtrxn);
    import ahb_types_pkg::*;
    `uvm_component_utils(ahb_mdriver)
    virtual ahb_if ahbif
    ahb_magent_cfg cfg;

    function new(string name = "ahb_mdriver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(ahb_magent_cfg)::get(this, "", "ahb_magent_cfg", cfg)) begin
            `uvm_fatal(get_full_name(), "No ahb_magent_cfg configured for ahb_mdriver")
        end
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        ahbif = cfg.ahbif;
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        
    endtask: run_phase

endclass: ahb_mdriver