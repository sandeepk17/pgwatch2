select
  (extract(epoch from now()) * 1e9)::int8 as epoch_ns,
  case
    when pg_is_in_recovery() = false then
      pg_xlog_location_diff(pg_current_xlog_location(), '0/0')::int8
    else
      pg_xlog_location_diff(pg_last_xlog_replay_location(), '0/0')::int8
    end as xlog_location_b,
  not pg_is_in_recovery() as is_primary,
  extract(epoch from (now() - pg_postmaster_start_time()))::int8 as postmaster_uptime_s;
