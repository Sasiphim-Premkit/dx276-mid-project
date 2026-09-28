-- วางทั้งหมดนี้ใน Supabase > SQL Editor แล้วกด Run ครั้งเดียว
create table if not exists public.players (
  id          text primary key,
  room        text not null,
  name        text not null,
  character   text not null,
  photo       text,                       -- รูปย่อขนาดเล็ก (data URL ~8-15 KB)
  created_at  timestamptz not null default now()
);
create index if not exists players_room_idx on public.players (room);

alter table public.players enable row level security;

-- เกมสำหรับงานอีเวนต์: ใครมีลิงก์ก็อ่าน/เข้าห้อง/ออกได้
drop policy if exists "read players"   on public.players;
drop policy if exists "insert players" on public.players;
drop policy if exists "update players" on public.players;
drop policy if exists "delete players" on public.players;
create policy "read players"   on public.players for select using (true);
create policy "insert players" on public.players for insert with check (char_length(name) <= 20 and char_length(coalesce(photo,'')) < 60000);
create policy "update players" on public.players for update using (true) with check (char_length(name) <= 20 and char_length(coalesce(photo,'')) < 60000);
create policy "delete players" on public.players for delete using (true);

-- เปิดเรียลไทม์ให้ตารางนี้
alter publication supabase_realtime add table public.players;
