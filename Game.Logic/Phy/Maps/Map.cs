using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.Phy.Maps
{
	public class Map
	{
		private MapInfo mapInfo_0;

		private float float_0;

		private HashSet<Physics> hashSet_0;

		protected Tile _layer1;

		protected Tile _layer2;

		protected Rectangle _bound;

		private Random random_0;

		public float wind
		{
			get
			{
				return float_0;
			}
			set
			{
				float_0 = value;
			}
		}

		public float gravity => mapInfo_0.Weight;

		public float airResistance => mapInfo_0.DragIndex;

		public Tile Ground => _layer1;

		public Tile DeadTile => _layer2;

		public MapInfo Info => mapInfo_0;

		public Rectangle Bound => _bound;

		public Map(MapInfo info, Tile layer1, Tile layer2)
		{
			mapInfo_0 = info;
			hashSet_0 = new HashSet<Physics>();
			random_0 = new Random();
			_layer1 = layer1;
			_layer2 = layer2;
			if (_layer1 != null)
			{
				_bound = new Rectangle(0, 0, _layer1.Width, _layer1.Height);
			}
			else
			{
				_bound = new Rectangle(0, 0, _layer2.Width, _layer2.Height);
			}
		}

		public void Dig(int cx, int cy, Tile surface, Tile border)
		{
			if (_layer1 != null)
			{
				_layer1.Dig(cx, cy, surface, border);
			}
			if (_layer2 != null)
			{
				_layer2.Dig(cx, cy, surface, border);
			}
		}

		public bool IsEmpty(int x, int y)
		{
			if (_layer1 != null && !_layer1.IsEmpty(x, y))
			{
				return false;
			}
			if (_layer2 != null)
			{
				return _layer2.IsEmpty(x, y);
			}
			return true;
		}

		public bool IsRectangleEmpty(Rectangle rect)
		{
			if (_layer1 != null && !_layer1.IsRectangleEmptyQuick(rect))
			{
				return false;
			}
			if (_layer2 != null)
			{
				return _layer2.IsRectangleEmptyQuick(rect);
			}
			return true;
		}

		public Point FindYLineNotEmptyPointDown(int x, int y, int h)
		{
			x = ((x >= 0) ? ((x >= _bound.Width) ? (_bound.Width - 1) : x) : 0);
			y = ((y >= 0) ? y : 0);
			h = ((y + h >= _bound.Height) ? (_bound.Height - y - 1) : h);
			int num = 0;
			while (true)
			{
				if (num < h)
				{
					if (!IsEmpty(x - 1, y) || !IsEmpty(x + 1, y))
					{
						break;
					}
					y++;
					num++;
					continue;
				}
				return Point.Empty;
			}
			return new Point(x, y);
		}

		public Point FindYLineNotEmptyPointDown(int x, int y)
		{
			return FindYLineNotEmptyPointDown(x, y, _bound.Height);
		}

		public Point FindYLineNotEmptyPointUp(int x, int y, int h)
		{
			x = ((x >= 0) ? ((x >= _bound.Width) ? _bound.Width : x) : 0);
			y = ((y >= 0) ? y : 0);
			h = ((y + h >= _bound.Height) ? (_bound.Height - y) : h);
			for (int index = 0; index < h; index++)
			{
				if (!IsEmpty(x - 1, y) || !IsEmpty(x + 1, y))
				{
					return new Point(x, y);
				}
				y--;
			}
			return Point.Empty;
		}

		public Point FindNextWalkPoint(int x, int y, int direction, int stepX, int stepY)
		{
			if (direction != 1 && direction != -1)
			{
				return Point.Empty;
			}
			int x2 = x + direction * stepX;
			if (x2 < 0 || x2 > _bound.Width)
			{
				return Point.Empty;
			}
			Point point = FindYLineNotEmptyPointDown(x2, y - stepY - 1, _bound.Width);
			if (point != Point.Empty && Math.Abs(point.Y - y) > stepY)
			{
				point = Point.Empty;
			}
			return point;
		}

		public List<Living> FindLiving(int fx, int tx, List<Living> exceptLivings)
		{
			List<Living> list = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics phy in hashSet_0)
				{
					bool result = true;
					if (!(phy is Living) || !phy.IsLiving || phy.X <= fx || phy.X >= tx)
					{
						continue;
					}
					if (exceptLivings != null && exceptLivings.Count != 0)
					{
						foreach (Living living in exceptLivings)
						{
							if (((Living)phy).Id == living.Id)
							{
								result = false;
								break;
							}
						}
						if (result)
						{
							list.Add(phy as Living);
						}
					}
					else
					{
						list.Add(phy as Living);
					}
				}
				return list;
			}
		}

		public Point FindNextWalkPointDown(int x, int y, int direction, int stepX, int stepY)
		{
			if (direction != 1 && direction != -1)
			{
				return Point.Empty;
			}
			int x2 = x + direction * stepX;
			if (x2 < 0 || x2 > _bound.Width)
			{
				return Point.Empty;
			}
			Point point = FindYLineNotEmptyPointDown(x2, y - stepY - 1);
			if (point != Point.Empty && Math.Abs(point.Y - y) > stepY)
			{
				point = Point.Empty;
			}
			return point;
		}

		public List<Living> FindRandomPlayer(int fx, int tx, List<Player> exceptPlayers)
		{
			List<Living> livingList1 = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (!(physics is Player) || !physics.IsLiving || physics.X <= fx || physics.X >= tx)
					{
						continue;
					}
					foreach (Player exceptPlayer in exceptPlayers)
					{
						if (((Player)physics).PlayerDetail == exceptPlayer.PlayerDetail)
						{
							livingList1.Add(physics as Living);
						}
					}
				}
			}
			List<Living> livingList2 = new List<Living>();
			if (livingList1.Count > 0)
			{
				livingList2.Add(livingList1[random_0.Next(livingList1.Count)]);
			}
			return livingList2;
		}

		public List<Living> FindRandomLiving(int fx, int tx)
		{
			List<Living> livingList1 = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if ((physics is SimpleNpc || physics is SimpleBoss) && physics.IsLiving && physics.X > fx && physics.X < tx)
					{
						livingList1.Add(physics as Living);
					}
				}
			}
			List<Living> livingList2 = new List<Living>();
			if (livingList1.Count > 0)
			{
				livingList2.Add(livingList1[random_0.Next(livingList1.Count)]);
			}
			return livingList2;
		}

		public bool canMove(int x, int y)
		{
			if (IsEmpty(x, y))
			{
				return !IsOutMap(x, y);
			}
			return false;
		}

		public bool IsOutMap(int x, int y)
		{
			if (x >= _bound.X && x <= _bound.Width)
			{
				return y > _bound.Height;
			}
			return true;
		}

		public void AddPhysical(Physics phy)
		{
			phy.SetMap(this);
			lock (hashSet_0)
			{
				hashSet_0.Add(phy);
			}
		}

		public void RemovePhysical(Physics phy)
		{
			phy.SetMap(null);
			lock (hashSet_0)
			{
				hashSet_0.Remove(phy);
			}
		}

		public List<Physics> GetAllPhysicalSafe()
		{
			List<Physics> physicsList = new List<Physics>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					physicsList.Add(physics);
				}
				return physicsList;
			}
		}

		public List<PhysicalObj> GetAllPhysicalObjSafe()
		{
			List<PhysicalObj> physicalObjList = new List<PhysicalObj>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is PhysicalObj)
					{
						physicalObjList.Add(physics as PhysicalObj);
					}
				}
				return physicalObjList;
			}
		}

		public Physics[] FindPhysicalObjects(Rectangle rect, Physics except)
		{
			List<Physics> physicsList = new List<Physics>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics.IsLiving && physics != except)
					{
						Rectangle bound = physics.Bound;
						Rectangle bound2 = physics.Bound1;
						bound.Offset(physics.X, physics.Y);
						bound2.Offset(physics.X, physics.Y);
						if (bound.IntersectsWith(rect) || bound2.IntersectsWith(rect))
						{
							physicsList.Add(physics);
						}
					}
				}
			}
			return physicsList.ToArray();
		}

		public bool FindPlayers(Point p, int radius)
		{
			int num = 0;
			lock (hashSet_0)
			{
				foreach (Physics item in hashSet_0)
				{
					if (item is Player && item.IsLiving && (item as Player).BoundDistance(p) < (double)radius)
					{
						num++;
					}
					if (num >= 2)
					{
						return true;
					}
				}
			}
			return false;
		}

		public List<Player> FindPlayers(int x, int y, int radius)
		{
			List<Player> playerList = new List<Player>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is Player && physics.IsLiving && physics.Distance(x, y) < (double)radius)
					{
						playerList.Add(physics as Player);
					}
				}
				return playerList;
			}
		}

		public List<Living> FindLivings(int x, int y, int radius)
		{
			List<Living> livingList = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is Living && physics.IsLiving && physics.Distance(x, y) < (double)radius)
					{
						livingList.Add(physics as Living);
					}
				}
				return livingList;
			}
		}

		public List<Living> FindPlayers(int fx, int tx, List<Player> exceptPlayers)
		{
			List<Living> livingList = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if ((!(physics is Player) && (!(physics is Living) || !(physics as Living).Config.IsHelper)) || !physics.IsLiving || physics.X <= fx || physics.X >= tx || (physics is Player && !(physics as Player).IsActive))
					{
						continue;
					}
					if (exceptPlayers != null)
					{
						foreach (Player exceptPlayer in exceptPlayers)
						{
							if (physics is Player && ((TurnedLiving)physics).DefaultDelay != exceptPlayer.DefaultDelay)
							{
								livingList.Add(physics as Living);
							}
						}
					}
					else
					{
						livingList.Add(physics as Living);
					}
				}
				return livingList;
			}
		}
		public List<Living> FindPlayers(int fx, int tx, List<Player> exceptPlayers, int fy, int ty)
		{
			List<Living> livings = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics hashSet0 in hashSet_0)
				{
					if (fy != 0 || ty != 0)
					{
						if (!(hashSet0 is Player) || !hashSet0.IsLiving || hashSet0.X <= fx || hashSet0.X >= tx || hashSet0.Y >= fy || hashSet0.Y <= ty)
						{
							continue;
						}
					}
					else
					{
						if (!(hashSet0 is Player) || !hashSet0.IsLiving || hashSet0.X <= fx || hashSet0.X >= tx)
						{
							continue;
						}
					}
					if (exceptPlayers == null)
					{
						livings.Add(hashSet0 as Living);
					}
					else
					{
						foreach (Player exceptPlayer in exceptPlayers)
						{
							if (((Player)hashSet0).PlayerDetail == exceptPlayer.PlayerDetail)
							{
								continue;
							}
							livings.Add(hashSet0 as Living);
						}
					}
				}
			}
			return livings;
		}
		public List<Living> FindHitByHitPiont(Point p, int radius)
		{
			List<Living> livingList = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is Living && physics.IsLiving && (physics as Living).BoundDistance(p) < (double)radius)
					{
						livingList.Add(physics as Living);
					}
				}
				return livingList;
			}
		}

		public Living FindNearestEnemy(int x, int y, double maxdistance, Living except)
		{
			Living living = null;
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is Living && physics != except && physics.IsLiving && ((Living)physics).Team != except.Team)
					{
						double num = physics.Distance(x, y);
						if (num < maxdistance)
						{
							living = physics as Living;
							maxdistance = num;
						}
					}
				}
				return living;
			}
		}

		public List<Living> FindAllNearestEnemy(int x, int y, double maxdistance, Living except)
		{
			List<Living> livingList = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics physics in hashSet_0)
				{
					if (physics is Living && physics != except && physics.IsLiving && ((Living)physics).Team != except.Team)
					{
						double num = physics.Distance(x, y);
						if (num < maxdistance)
						{
							livingList.Add(physics as Living);
							maxdistance = num;
						}
					}
				}
				return livingList;
			}
		}

		public List<Living> FindAllNearestSameTeam(int x, int y, double maxdistance, Living except)
		{
			List<Living> list = new List<Living>();
			lock (hashSet_0)
			{
				foreach (Physics item in hashSet_0)
				{
					if (item is Living && item != except && item.IsLiving && ((Living)item).Team == except.Team)
					{
						double num = item.Distance(x, y);
						if (num < maxdistance)
						{
							list.Add(item as Living);
							maxdistance = num;
						}
					}
				}
				return list;
			}
		}

		public List<Living> GetAllLivings()
		{
			var livings = new List<Living>();
			lock (hashSet_0)
			{
				foreach (var obj in hashSet_0)
				{
					if ((obj is SimpleNpc || obj is SimpleBoss) && obj.IsLiving)
					{
						livings.Add(obj as Living);
					}
				}
			}
			return livings;
		}

		public List<Living> GetAllPlayers()
		{
			var livings = new List<Living>();
			lock (hashSet_0)
			{
				foreach (var obj in hashSet_0)
				{
					if (obj is Player item && item.IsLiving)
					{
						livings.Add(item);
					}
				}
			}
			return livings;
		}

		public void Dispose()
		{
			foreach (Physics item in hashSet_0)
			{
				item.Dispose();
			}
		}

		public Map Clone()
		{
			return new Map(mapInfo_0, (_layer1 != null) ? _layer1.Clone() : null, (_layer2 != null) ? _layer2.Clone() : null);
		}
	}
}
