note
	description: "Represent a reference between OBJECT_NODEs"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2009-09-29 06:26:59 +0200 (tis, 29 sep 2009) $"
	revision: "$Revision: 80947 $"

class
	MA_REFERENCE_LINK

inherit
	EG_LINK_FIGURE
		redefine
			default_create,
			xml_node_name
		end

create
	make

create {MA_REFERENCE_LINK}
	make_resized_from

feature {NONE} -- Initialization

	default_create
			-- Create an EG_SIMPLE_LINK.
		do
			create line
			create reflexive.make_with_positions (0, 0, 10, 10)

			Precursor {EG_LINK_FIGURE}

			extend (line)
		end

	make (a_model: EG_LINK; a_source, a_target: like source)
			-- Make a link using `a_model' as `model', `a_source' as `source' and `a_target' as `target'.
		require
			a_model_not_void: a_model /= Void
		do
			model := a_model
			source := a_source
			target := a_target
			default_create
			initialize

			if a_model.is_directed then
				line.enable_end_arrow
			end
			if a_model.is_reflexive then
				prune_all (line)
				extend (reflexive)
			end

			disable_moving
			disable_scaling
			disable_rotating

			update
		ensure
			model_set: model = a_model
			source_set: source = a_source
			target_set: target = a_target
			moving_disabled: not is_moving
			scaling_disabled: not is_scaling
			rotating_disabled: not is_rotating
		end

	make_resized_from (a_other: like Current; n: INTEGER)
			-- Make a link using `a_other'
			-- and resize the freshly created area with a count of `n'.
		do
			make (a_other.model, a_other.source, a_other.target)
			area_v2 := area_v2.resized_area (n)
		ensure
			same_model: model = a_other.model
			same_source_and_target: source = a_other.source and target = a_other.target
			area_count: area_v2.count = n
		end

feature -- Access

	set_color
			-- Set the color of the reference line.
		do
			line.set_foreground_color ((create{EV_STOCK_COLORS}).red)
		end

	set_color_back
			-- Set the color of the reference line to the orignal color.
		do
			line.set_foreground_color ((create{EV_STOCK_COLORS}).black)
		end

	xml_node_name: STRING
			-- <Precursor>
		do
			Result := "EG_SIMPLE_LINK"
		end

	arrow_size: INTEGER
			-- Size of the arrow.
		do
			Result := line.arrow_size
		end

feature -- Element change

	set_arrow_size (i: INTEGER)
			-- Set `arrow_size' to `i'.
		require
			i_positive: i > 0
		do
			line.set_arrow_size (i)
		ensure
			set: arrow_size = i
		end

feature {EG_FIGURE, EG_FIGURE_WORLD} -- Update

	update
			-- <Precursor>
		local
			p1, p2: EV_COORDINATE
			an_angle: DOUBLE
			source_size: EV_RECTANGLE
		do
			if not model.is_reflexive then
				if attached source as l_source and then attached target as l_target then
					p1 := line.point_array.item (0)
					p2 := line.point_array.item (1)

					p1.set (l_source.port_x, l_source.port_y)
					p2.set (l_target.port_x, l_target.port_y)

					an_angle := line_angle (p1.x_precise, p1.y_precise, p2.x_precise, p2.y_precise)
					l_source.update_edge_point (p1, an_angle)
					an_angle := pi + an_angle
					l_target.update_edge_point (p2, an_angle)
				elseif attached source as l_source_2 then
					p1 := line.point_array.item (0)
					p1.set (l_source_2.port_x, l_source_2.port_y)
					l_source_2.update_edge_point (p1, 0)
				elseif attached target as l_target_2 then
					p2 := line.point_array.item (1)
					p2.set (l_target_2.port_x, l_target_2.port_y)
					l_target_2.update_edge_point (p2, 0)
				end

				line.invalidate
				line.center_invalidate
				if is_label_shown then
					name_label.set_point_position (line.x, line.y)
				end
			else
				if attached source as l_source_3 then
					source_size := l_source_3.size
					reflexive.set_x_y (source_size.right + reflexive.radius1, source_size.top + source_size.height // 2)
				end
				if is_label_shown then
					name_label.set_point_position (reflexive.x + reflexive.radius1, reflexive.y)
				end
			end
			is_update_required := False
		end

feature {NONE} -- Implementation

	set_is_selected (an_is_selected: like is_selected)
			-- <Precursor>
		do
			is_selected := an_is_selected
		end

	line: EV_MODEL_LINE
			-- The rectangle representing the link.

	reflexive: EV_MODEL_ELLIPSE
			-- The ellipse used when link `is_reflexive'.

	on_is_directed_change
			-- <Precursor>
		do
			if model.is_directed then
				line.enable_end_arrow
			else
				line.disable_end_arrow
			end
			line.invalidate
			line.center_invalidate
		end

	new_filled_list (n: INTEGER): like Current
			-- <Precursor>
		do
			create Result.make_resized_from (Current, n)
		end

invariant
	line_not_void: line /= Void
	mdeol_not_void: model /= Void

note
	copyright:	"Copyright (c) 1984-2014, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end
