import ahb_types_pkg::*;
`include "uvm_macro.svh"

class ahb_mdriver extends uvm_driver #(ahb_mtrxn);
    `uvm_component_utils(ahb_mdriver)
endclass: ahb_mdriver