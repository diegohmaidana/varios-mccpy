/*﻿begin transaction;*/
truncate table public.per_neike;
insert into public.per_neike
 select *
from
 public.per_neike_v;
reindex table public.per_neike;
/*commit;*/
