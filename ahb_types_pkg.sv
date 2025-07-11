package ahb_types_pkg;

    // This package defines the AHB types used in the AHB master agent
    typedef enum bit [1:0] {
        IDLE,
        BUSY,
        NONSEQ,
        SEQ
    } transfer_t;

    typedef enum bit [2:0] {
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

    typedef enum bit [1:0]{
        BYTE = 2'b00,
        HALFWORD = 2'b01,
        WORD = 2'b10,
        ERROR_SIZE = 2'b11
    } size_t;
endpackage