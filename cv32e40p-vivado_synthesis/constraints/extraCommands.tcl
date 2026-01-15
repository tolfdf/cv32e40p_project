proc remove_from_collection { collection collectiontoremove } {
    foreach toremove $collectiontoremove {
        set collection [lsearch -inline -all -not -exact $collection $toremove]
    }
    return $collection
}

proc get_logic_cone { cell } {
    set cell [get_cells $cell]
#    set nets [get_nets -of_objects $cell]
#    set pins [get_pins -of_objects $cell]
    set precone [all_fanin -flat -startpoints_only [get_nets -of $cell]] ## get_pins ?
    set postcone [all_fanout -flat -endpoints_only [get_nets -of $cell]] ## get_pins ?
}

proc merge_register_indices { l } {
    foreach c $l {
        lappend merged [lindex [regexp -inline {(.*)\[.*} $c] 1] ## remove {i} indices
    }
    return [lsort -unique $merged]
}
