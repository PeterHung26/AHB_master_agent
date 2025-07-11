`include "uvm_macros.svh"

class ahb_magent_cfg extends uvm_object;
    `uvm_obect_utils(ahb_magent_cfg)
    virtual ahb_if ahbif;
    uvm_active_passive_enum active = UVM_ACTIVE;

    function new(string name = "ahb_magent_cfg");
        super.new(name);
    endfunction: new
endclass: ahb_magent_cfg