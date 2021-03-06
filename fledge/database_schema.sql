BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "scenarios" (
	"scenario_name"	TEXT,
	"display_id"	TEXT,
	"electric_grid_name"	TEXT,
	"thermal_grid_name"	TEXT,
	"case_name"	TEXT,
	"optimal_scheduling_problem_name"	TEXT,
	"timestep_start"	TEXT,
	"timestep_end"	TEXT,
	"timestep_interval_seconds"	TEXT,
	PRIMARY KEY("scenario_name")
);
CREATE TABLE IF NOT EXISTS "operation_switch_timeseries" (
	"switch_name"	TEXT,
	"scenario_name"	TEXT,
	"time"	TEXT,
	"is_closed"	INTEGER,
	PRIMARY KEY("time","scenario_name","switch_name")
);
CREATE TABLE IF NOT EXISTS "operation_problems" (
	"optimal_scheduling_problem_name"	TEXT,
	"maximum_voltage_per_unit"	REAL,
	"minimum_voltage_per_unit"	REAL,
	"price_slack"	REAL,
	"price_flexible_load"	REAL,
	"maximum_voltage_imbalance"	REAL,
	PRIMARY KEY("optimal_scheduling_problem_name")
);
CREATE TABLE IF NOT EXISTS "operation_load_timeseries" (
	"load_name"	TEXT,
	"scenario_name"	TEXT,
	"time"	TEXT,
	"active_power"	REAL,
	"reactive_power"	REAL,
	PRIMARY KEY("load_name","scenario_name","time")
);
CREATE TABLE IF NOT EXISTS "operation_line_timeseries" (
	"line_name"	TEXT,
	"scenario_name"	TEXT,
	"time"	TEXT,
	"phase"	REAL,
	"terminal"	REAL,
	"active_power"	REAL,
	"reactive_power"	REAL,
	PRIMARY KEY("line_name","scenario_name","time","phase","terminal")
);
CREATE TABLE IF NOT EXISTS "operation_node_timeseries" (
	"node_name"	TEXT,
	"scenario_name"	TEXT,
	"time"	TEXT,
	"phase"	TEXT,
	"voltage_magnitude"	REAL,
	"voltage_angle"	REAL,
	"active_power"	REAL,
	"reactive_power"	REAL,
	PRIMARY KEY("node_name","scenario_name","time","phase")
);
CREATE TABLE IF NOT EXISTS "price_timeseries" (
	"price_name"	TEXT,
	"market_name"	TEXT,
	"time"	TEXT,
	"price_value"	REAL,
	PRIMARY KEY("price_name","time","market_name")
);
CREATE TABLE IF NOT EXISTS "electric_grids" (
	"electric_grid_name"	TEXT,
	"source_node_name"	TEXT,
	"source_voltage"	REAL,
	"n_phases"	INTEGER,
	"voltage_bases_string"	TEXT,
	"load_multiplier"	REAL,
	"control_mode_string"	TEXT,
	"extra_definitions_string"	TEXT,
	"has_extra_definitions_file"	REAL,
	"dashboard_map_zoom"	TEXT,
	PRIMARY KEY("electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_transformers" (
	"transformer_name"	TEXT,
	"electric_grid_name"	TEXT,
	"winding"	INTEGER,
	"node_name"	TEXT,
	"is_phase_0_connected"	INTEGER,
	"is_phase_1_connected"	INTEGER,
	"is_phase_2_connected"	INTEGER,
	"is_phase_3_connected"	INTEGER,
	"n_phases"	INTEGER,
	"connection"	TEXT,
	"power"	REAL,
	"resistance_percentage"	REAL,
	PRIMARY KEY("winding","electric_grid_name","transformer_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_transformer_taps" (
	"transformer_name"	TEXT,
	"electric_grid_name"	TEXT,
	"winding"	INTEGER,
	"tap_maximum_voltage_per_unit"	REAL,
	"tap_minimum_voltage_per_unit"	REAL,
	PRIMARY KEY("electric_grid_name","transformer_name","winding")
);
CREATE TABLE IF NOT EXISTS "electric_grid_transformer_reactances" (
	"transformer_name"	TEXT,
	"electric_grid_name"	TEXT,
	"row"	INTEGER,
	"col"	INTEGER,
	"reactance_percentage"	REAL,
	PRIMARY KEY("transformer_name","row","col","electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_switches" (
	"switch_name"	TEXT,
	"electric_grid_name"	TEXT,
	"n_phases"	INTEGER,
	"node_1_name"	TEXT,
	"node_2_name"	TEXT,
	"is_phase_0_connected"	INTEGER,
	"is_phase_1_connected"	INTEGER,
	"is_phase_2_connected"	INTEGER,
	"is_phase_3_connected"	INTEGER,
	"is_closed"	INTEGER,
	PRIMARY KEY("switch_name","electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_ders" (
	"der_name"	TEXT,
	"electric_grid_name"	TEXT,
	"der_type"	TEXT,
	"model_name"	TEXT,
	"node_name"	TEXT,
	"is_phase_0_connected"	INTEGER,
	"is_phase_1_connected"	INTEGER,
	"is_phase_2_connected"	INTEGER,
	"is_phase_3_connected"	INTEGER,
	"n_phases"	INTEGER,
	"connection"	TEXT,
	"active_power"	REAL,
	"reactive_power"	REAL,
	PRIMARY KEY("der_name","electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_lines" (
	"line_name"	TEXT,
	"electric_grid_name"	TEXT,
	"line_type"	TEXT,
	"node_1_name"	TEXT,
	"node_2_name"	TEXT,
	"is_phase_0_connected"	INTEGER,
	"is_phase_1_connected"	INTEGER,
	"is_phase_2_connected"	INTEGER,
	"is_phase_3_connected"	INTEGER,
	"length"	REAL,
	PRIMARY KEY("line_name","electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "electric_grid_line_types_matrices" (
	"line_type"	TEXT,
	"row"	INTEGER,
	"col"	INTEGER,
	"r"	REAL,
	"x"	REAL,
	"c"	REAL,
	PRIMARY KEY("line_type","row","col")
);
CREATE TABLE IF NOT EXISTS "electric_grid_line_types" (
	"line_type"	TEXT,
	"n_phases"	INTEGER,
	"base_frequency"	REAL,
	"maximum_current"	REAL,
	PRIMARY KEY("line_type")
);
CREATE TABLE IF NOT EXISTS "electric_grid_nodes" (
	"node_name"	TEXT,
	"electric_grid_name"	TEXT,
	"is_phase_0_connected"	INTEGER,
	"is_phase_1_connected"	INTEGER,
	"is_phase_2_connected"	INTEGER,
	"is_phase_3_connected"	INTEGER,
	"voltage"	REAL,
	"latitude"	REAL,
	"longitude"	REAL,
	"node_annotation"	TEXT,
	PRIMARY KEY("node_name","electric_grid_name")
);
CREATE TABLE IF NOT EXISTS "flexible_loads" (
	"model_name"	TEXT,
	"case_name"	TEXT,
	"timeseries_name"	TEXT,
	"scaling_factor"	REAL,
	"power_increase_percentage_maximum"	REAL,
	"power_decrease_percentage_maximum"	REAL,
	"time_period_power_shift_maximum"	REAL,
	PRIMARY KEY("model_name","case_name")
);
CREATE TABLE IF NOT EXISTS "flexible_load_timeseries" (
	"timeseries_name"	TEXT,
	"time"	TEXT,
	"apparent_power_per_unit"	REAL,
	PRIMARY KEY("timeseries_name","time")
);
CREATE TABLE IF NOT EXISTS "fixed_loads" (
	"model_name"	TEXT,
	"case_name"	TEXT,
	"timeseries_name"	TEXT,
	"scaling_factor"	REAL,
	PRIMARY KEY("model_name","case_name")
);
CREATE TABLE IF NOT EXISTS "fixed_load_timeseries" (
	"timeseries_name"	TEXT,
	"time"	TEXT,
	"apparent_power_per_unit"	REAL,
	PRIMARY KEY("timeseries_name","time")
);
CREATE TABLE IF NOT EXISTS "ev_chargers" (
	"model_name"	TEXT,
	"case_name"	TEXT,
	"timeseries_name"	TEXT,
	"use_per_unit"	REAL,
	"scaling_factor"	REAL,
	PRIMARY KEY("model_name","case_name")
);
CREATE TABLE IF NOT EXISTS "ev_charger_timeseries" (
	"timeseries_name"	TEXT,
	"time"	TEXT,
	"apparent_power"	REAL,
	"apparent_power_per_unit"	REAL,
	PRIMARY KEY("timeseries_name","time")
);
CREATE TABLE IF NOT EXISTS "thermal_grid_cooling_plant_types" (
	"cooling_plant_type"	TEXT,
	"pumping_total_efficiency"	REAL,
	"pump_head_cooling_water"	REAL,
	"pump_head_evaporators"	REAL,
	"chiller_set_beta"	REAL,
	"chiller_set_delta_temperature_cnd_min"	REAL,
	"chiller_set_evaporation_temperature"	REAL,
	"chiller_set_cooling_capacity"	REAL,
	"cooling_water_delta_temperature"	REAL,
	"cooling_tower_set_reference_temperature_cooling_water_supply"	REAL,
	"cooling_tower_set_reference_temperature_wet_bulb"	REAL,
	"cooling_tower_set_reference_temperature_slope"	REAL,
	"cooling_tower_set_ventilation_factor"	REAL,
	PRIMARY KEY("cooling_plant_type")
);
CREATE TABLE IF NOT EXISTS "thermal_grid_ders" (
	"thermal_grid_name"	TEXT,
	"der_name"	TEXT,
	"node_name"	TEXT,
	"der_type"	TEXT,
	"model_name"	TEXT,
	"thermal_power_nominal"	REAL,
	PRIMARY KEY("thermal_grid_name","der_name")
);
CREATE TABLE IF NOT EXISTS "thermal_grid_lines" (
	"thermal_grid_name"	TEXT,
	"line_name"	TEXT,
	"node_1_name"	TEXT,
	"node_2_name"	TEXT,
	"length"	REAL,
	"diameter"	REAL,
	"absolute_roughness"	REAL,
	PRIMARY KEY("thermal_grid_name","line_name")
);
CREATE TABLE IF NOT EXISTS "thermal_grid_nodes" (
	"thermal_grid_name"	TEXT,
	"node_name"	TEXT,
	"node_type"	TEXT,
	"latitude"	REAL,
	"longitude"	REAL,
	PRIMARY KEY("thermal_grid_name","node_name")
);
CREATE TABLE IF NOT EXISTS "thermal_grids" (
	"thermal_grid_name"	TEXT,
	"enthalpy_difference_distribution_water"	REAL,
	"enthalpy_difference_cooling_water"	REAL,
	"water_density"	REAL,
	"water_kinematic_viscosity"	REAL,
	"pump_efficiency_secondary_pump"	REAL,
	"ets_head_loss"	REAL,
	"pipe_velocity_maximum"	REAL,
	"cooling_plant_type"	TEXT,
	PRIMARY KEY("thermal_grid_name")
);
COMMIT;
