begin transaction;

create temp table automotores_temp (like vinemp.automotores) on commit drop;

insert into automotores_temp
	select 
		dominio,
		marca,
		modelo,
		ano_fab,
		fecha_rad,
		fecha_baja,
		num_motor,
		num_chassis,
		tipo_vehiculo,
		apyn,
		documento,
		cuit,
		domicilio,
		accion,
		procesado,
		id
	from
		(SELECT va.*,ta.dominio as tadominio
		FROM 
			vinemp.automotores va 
			LEFT OUTER JOIN transp.automotores ta ON va.dominio = ta.dominio) as c1
	WHERE
		tadominio is null
		AND accion = 'I'	
		AND procesado = false;

insert into transp.automotores 
	select 
		dominio,
		marca,
		modelo,
		ano_fab,
		fecha_rad,
		fecha_baja,
		num_motor,
		num_chassis,
		tipo_vehiculo,
		apyn,
		documento,
		cuit,
		domicilio
	from 
		automotores_temp;

update vinemp.automotores set procesado = true where id  in (select id from automotores_temp)  ;


create temp table automotores_temp_u (like vinemp.automotores) on commit drop;

insert into automotores_temp_u
	select 
		dominio,
		marca,
		modelo,
		ano_fab,
		fecha_rad,
		fecha_baja,
		num_motor,
		num_chassis,
		tipo_vehiculo,
		apyn,
		documento,
		cuit,
		domicilio,
		accion,
		procesado,
		id
	from
		(SELECT va.*,ta.dominio as tadominio
		FROM 
			vinemp.automotores va 
			LEFT OUTER JOIN transp.automotores ta ON va.dominio = ta.dominio) as c1
	WHERE
		tadominio is not null
		AND accion = 'U'
		AND procesado = false;


update transp.automotores 
	set 
	
		dominio = tt.dominio,
		marca = tt.marca,
		modelo = tt.modelo,
		ano_fab = tt.ano_fab,
		fecha_rad = tt.fecha_rad,
		fecha_baja = tt.fecha_baja,
		num_motor = tt.num_motor,
		num_chassis = tt.num_chassis,
		tipo_vehiculo = tt.tipo_vehiculo,
		apyn = tt.apyn,
		documento = tt.documento,
		cuit = tt.cuit,
		domicilio = tt.domicilio
	

	from 
		automotores_temp_u tt
	where
		tt.dominio = automotores.dominio;

update vinemp.automotores set procesado = true where id  in (select id from automotores_temp_u)  ;

delete from vinemp.automotores where procesado is true;

insert into vinemp.log_automotores 
( id,	fecha,	script,	insertados,	modificados)
VALUES 
(   default,now(),'automotores',
		(SELECT
			count(auditoria_fecha) cantidad
		FROM transp_auditoria.logs_automotores 
		WHERE 
			substr(auditoria_fecha::text,1,10)::date = CURRENT_DATE
			AND auditoria_operacion = 'I'
		),
		(SELECT
			count(auditoria_fecha) cantidad
			FROM transp_auditoria.logs_automotores 
		WHERE 
			substr(auditoria_fecha::text,1,10)::date = CURRENT_DATE
			AND auditoria_operacion = 'U'
		)
);

commit;

