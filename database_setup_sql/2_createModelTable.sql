-- every model has a make
-- every model has a trimid
-- but they do not identify every row in this table (eg. same model, same trim, but auto vs.manual)
-- created model_id field - hash of the other fields

CREATE TABLE `model` (
  `model_id` VARCHAR(255) NOT NULL,
  `model_name` VARCHAR(255) NOT NULL,
  `trimid` VARCHAR(45) NOT NULL DEFAULT 't0',
  `trim_name` VARCHAR(255) NULL DEFAULT NULL,
  `body_type` VARCHAR(45) NOT NULL DEFAULT 'Other',
  `transmission` VARCHAR(45) NULL DEFAULT NULL,
  `transmission_display` VARCHAR(45) NULL DEFAULT NULL,
  `wheel_system` VARCHAR(45) NULL DEFAULT NULL,
  `wheel_system_display` VARCHAR(45) NULL DEFAULT NULL,
  `back_legroom` FLOAT(2) NULL DEFAULT NULL,
  `front_legroom` FLOAT(2) NULL DEFAULT NULL,
  `highway_fuel_economy` INT NULL DEFAULT NULL,  
  `city_fuel_economy` INT NULL DEFAULT NULL,
  `combine_fuel_economy` INT NULL DEFAULT NULL,
  `fuel_tank_volume` FLOAT(2) NULL DEFAULT NULL,
  `fuel_type` VARCHAR(45) NULL DEFAULT NULL,
  `height` FLOAT(2) NULL DEFAULT NULL,
  `length` FLOAT(2) NULL DEFAULT NULL,
  `width` FLOAT(2) NULL DEFAULT NULL,
  `interior_color` VARCHAR(255) NULL DEFAULT NULL,
  `exterior_color` VARCHAR(255) NULL DEFAULT NULL,
  `wheelbase` FLOAT(2) NULL DEFAULT NULL,
  `power` VARCHAR(45) NULL DEFAULT NULL,
  `franchise_make` VARCHAR(45) NULL DEFAULT NULL,
  `year` INT NOT NULL,
  `maximum_seating` INT NULL DEFAULT NULL,
  `horsepower` INT NULL DEFAULT NULL,
  `engine_type` VARCHAR(45) NULL DEFAULT NULL,
  `engine_cylinders` VARCHAR(45) NULL DEFAULT NULL,
  `engine_displacement` INT NULL DEFAULT NULL,
  `torque` VARCHAR(45) NULL DEFAULT NULL,
PRIMARY KEY (`model_id`),
UNIQUE INDEX `model_id_UNIQUE` (`model_id` ASC) VISIBLE,
INDEX `model_idx` (`body_type` ASC, `year` ASC, `maximum_seating` ASC, `engine_type` ASC) VISIBLE);


INSERT INTO model
SELECT DISTINCT
  md5(concat(`model_name`, `trimid`, `trim_name`, `body_type`, `transmission`, `transmission_display`, `wheel_system`, `wheel_system_display`, `back_legroom`, `front_legroom`, `highway_fuel_economy`, `city_fuel_economy`, `combine_fuel_economy`, `fuel_tank_volume`, `fuel_type`, `height`, `length`, `width`, `interior_color`, `exterior_color`, `wheelbase`, `power`, `franchise_make`, `year`, `maximum_seating`, `horsepower`, `engine_type`, `engine_cylinders`, `engine_displacement`, `torque`)) model_id,
  model_name,
  (case when trimid='' then 't0' else trimid end) trimid,
  (case when trim_name='' then 't0' else trim_name end) trim_name,
  (case when body_type='' then 'Other' else body_type end) body_type,
  (case when transmission='' then null else transmission end) transmission,
  (case when transmission_display='' then null else transmission_display end) transmission_display,
  (case when wheel_system='' then null else wheel_system end) wheel_system,
  (case when wheel_system_display='' then null else wheel_system_display end) wheel_system_display,
  (case when back_legroom='' then null else cast(substring_index(back_legroom,' ',1) as float) end) back_legroom,
  (case when front_legroom='' then null else cast(substring_index(front_legroom,' ',1) as float) end) front_legroom,
  (case when highway_fuel_economy='' then null else cast(highway_fuel_economy as unsigned) end) highway_fuel_economy, 
  (case when city_fuel_economy='' then null else cast(city_fuel_economy as unsigned) end) city_fuel_economy, 
  (case when combine_fuel_economy='' then null else combine_fuel_economy end)combine_fuel_economy,
  (case when fuel_tank_volume='' then null else cast(substring_index(fuel_tank_volume,' ',1) as float) end) fuel_tank_volume,
  (case when fuel_type='' then null else fuel_type end) fuel_type,
  (case when height='' then null else cast(substring_index(height,' ',1) as float) end) height,
  (case when length='' then null else cast(substring_index(length,' ',1) as float) end) length,
  (case when width='' then null else cast(substring_index(width,' ',1) as float) end) width,
  (case when interior_color='?' then null else interior_color end) interior_color,
  exterior_color,
  (case when wheelbase='' then null else cast(substring_index(wheelbase,' ',1) as float) end) wheelbase,
  (case when power='' then null else replace(power,';','') end) power,
  (case when franchise_make='' then null else franchise_make end) franchise_make,
  cast(`year` as unsigned) `year`,
  (case when maximum_seating='' then null else cast(substring_index(maximum_seating,' ',1) as float) end) maximum_seating,
  (case when horsepower='' then null else cast(horsepower as unsigned) end) horsepower,
  (case when engine_type='' then null else engine_type end) engine_type,
  (case when engine_cylinders='' then null else engine_cylinders end) engine_cylinders,
  (case when engine_displacement='' then null else cast(engine_displacement as unsigned) end) engine_displacement,
  (case when torque='' then null else replace(torque,';','') end) torque
FROM fullcsv;