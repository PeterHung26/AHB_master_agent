package ahb_types_pkg;
    localparam int ADDR_WIDTH = 32;
    localparam int HBURST_WIDTH = 3;
    // HPROT_WIDTH must be 0, 4, or 7, depending on the Extended_Memory_Types property.
    localparam int HPROT_WIDTH = 0;
    //  HMASTER_WIDTH is recommended to be between 0 and 8
    localparam int HMASTER_WIDTH = 0;
    localparam int DATA_WIDTH = 32;
    // This package defines the AHB types used in the AHB master agent
    typedef enum bit [1:0] {
        IDLE,
        BUSY,
        NONSEQ,
        SEQ
    } transfer_t;

    typedef enum bit [HBURST_WIDTH-1:0] {
        SINGLE = 3'b000,
        INCR = 3'b001,
        WRAP4 = 3'b010,
        INCR4 = 3'b011,
        WRAP8 = 3'b100,
        INCR8 = 3'b101,
        WRAP16 = 3'b110,
        INCR16 = 3'b111
    } burst_t;

    typedef enum bit{
        OKAY,
        ERROR
    } resp_t;

    typedef enum bit{
        READ,
        WRITE
    } rw_t;

    typedef enum bit [2:0]{
        BYTE = 3'b000,
        HALFWORD = 3'b001,
        WORD = 3'b010,
        WORDX2 = 3'b011,
        WORDX4 = 3'b100,
        WORDX8 = 3'b101,
        WORDX16 = 3'b110,
        WORDX32 = 3'b111
    } size_t;
endpackage