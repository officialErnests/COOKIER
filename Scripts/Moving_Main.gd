extends Control

func _process(delta: float) -> void:
    for child_node in get_children():
        if child_node.is_class("Control"):
            var t_new_pos = (Vector2(0.5,0.5)-(get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size)) * -5 * child_node.z_index
            child_node.position += (t_new_pos - child_node.position) * delta * 10