
interface ahb_if(input logic HCLK);
    import ahb_types_pkg::*;
    // Global signal
    logic HRESETn;
    // Manager signals
    logic [ADDR_WIDTH-1:0] HADDR;
    logic [HBURST_WIDTH-1:0] HBURST;
    logic [2:0] HSIZE;
    logic [1:0] HTRANS;
    logic [DATA_WIDTH-1:0] HWDATA;
    logic HWRITE;
    // Subordinate signals
    logic [DATA_WIDTH-1:0] HRDATA;
    logic HREADOUT;
    logic HRESP;
    // Decoder signals
    // Maybe I need to build a decoder for the HSEL signal
    logic HSEL;

    clocking mdrv_cb@(posedge HCLK);
        default input #1ns output #0ns;
        output HADDR;
        output HBURST;
        output HSIZE;
        output HTRANS;
        output HWDATA;
        output HWRITE;
        input HRDATA;
        input HREADYOUT;
        input HRESP;
    endclocking

    modport MDRV_MP (
    clocking mdrv_cb,
    input HRESETn,
    );

endinterface //ahb_if