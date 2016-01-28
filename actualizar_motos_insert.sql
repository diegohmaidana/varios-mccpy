begin transaction;

create temp table motos_temp (like vinemp.motos) on commit drop;

insert into motos_temp
	select 
		dominio
		,marca
		,modelo
		,cilindrada
		,categoria
		,ano_fab
		,fecha_rad
		,fecha_baja
		,num_motor
		,num_chassis
		,apyn
		,documento
		,cuit
		,domicilio
		,accion
		,procesado
		,id
 	from
		(SELECT vm.*,tm.dominio as tmdominio
		FROM 
			vinemp.motos vm 
			LEFT OUTER JOIN transp.motos tm ON vm.dominio = tm.dominio) as c1
	WHERE
		tmdominio is null
		and accion = 'I'
		AND procesado = false;


insert into transp.motos 
	select 
		dominio
		,marca
		,modelo
		,cilindrada
		,categoria
		,ano_fab
		,fecha_rad
		,fecha_baja
		,num_motor
		,num_chassis
		,apyn
		,documento
		,cuit
		,domicilio
  
	from 
		motos_temp;

update vinemp.motos set procesado = true where id  in (select id from motos_temp)  ;


create temp table motos_temp_u (like vinemp.motos) on commit drop;

insert into motos_temp_u
	select 
		dominio
		,marca
		,modelo
		,cilindrada
		,categoria
		,ano_fab
		,fecha_rad
		,fecha_baja
		,num_motor
		,num_chassis
		,apyn
		,documento
		,cuit
		,domicilio
		,accion
		,procesado
		,id
	 from
		(SELECT vm.*,tm.dominio as tmdominio
		FROM 
			vinemp.motos vm 
			LEFT OUTER JOIN transp.motos tm ON vm.dominio = tm.dominio) as c1
	WHERE
		tmdominio is not null
		and accion = 'U'
		AND procesado = false;

update transp.motos
	set 
	
		dominio = tt.dominio
		,marca = tt.marca
		,modelo = tt.modelo
		,cilindrada = tt.cilindrada
		,categoria = tt.categoria
		,ano_fab = tt.ano_fab
		,fecha_rad = tt.fecha_rad
		,fecha_baja = tt.fecha_baja
		,num_motor = tt.num_motor
		,num_chassis = tt.num_chassis
		,apyn = tt.apyn
		,documento = tt.documento
		,cuit = tt.cuit
		,domicilio = tt.documento
	

	from 
		motos_temp_u tt
	where
		tt.dominio = motos.dominio;

update vinemp.motos set procesado = true where id  in (select id from motos_temp_u)  ;

delete from vinemp.motos where procesado is true;

insert into vinemp.log_automotores 
( id,	fecha,	script,	insertados,	modificados)
VALUES 
(   default,now(),'motos',
		(SELECT
			count(auditoria_fecha) cantidad
		FROM transp_auditoria.logs_motos 
		WHERE 
			substr(auditoria_fecha::text,1,10)::date = CURRENT_DATE
			AND auditoria_operacion = 'I'
		),
		(SELECT
			count(auditoria_fecha) cantidad
			FROM transp_auditoria.logs_motos 
		WHERE 
			substr(auditoria_fecha::text,1,10)::date = CURRENT_DATE
			AND auditoria_operacion = 'U'
		)
);

commit;