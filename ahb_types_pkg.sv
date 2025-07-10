package ahb_types_pkg;

    // This package defines the AHB types used in the AHB master agent
    typedef enum logic [1:0] {
        IDLE,
        BUSY,
        NONSEQ,
        SEQ
    } transfer_t;

    typedef enum logic [2:0] {
        SINGLE,
        INCR,
        WRAP4,
        INCR4,
        WRAP8,
        INCR8,
        WRAP16,
        INCR16
    } burst_t;

    typedef enum logic{
        OKAY,
        ERROR
    } resp_t;

    typedef enum logic{
        READ,
        WRITE
    } rw_t;
endpackage