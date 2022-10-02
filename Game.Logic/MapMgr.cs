using Bussiness;
using Game.Logic.Phy.Maps;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Logic
{
    public class MapMgr
    {
        private static Dictionary<int, Map> _mapInfos;

        private static Dictionary<int, MapPoint> _maps;

        private static Dictionary<int, List<int>> _serverMap;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        private static ThreadSafeRandom random;

        public static int GetWeekDay
        {
			get
			{
				int num = Convert.ToInt32(DateTime.Now.DayOfWeek);
				if (num != 0)
				{
					return num;
				}
				return 7;
			}
        }

        public static Map CloneMap(int index)
        {
			if (_mapInfos.ContainsKey(index))
			{
				return _mapInfos[index].Clone();
			}
			return null;
        }

        public static MapInfo FindMapInfo(int index)
        {
			if (_mapInfos.ContainsKey(index))
			{
				return _mapInfos[index].Info;
			}
			return null;
        }

        public static int GetMapIndex(int index, byte type, int serverId)
        {
			if (index != 0 && !_maps.Keys.Contains(index))
			{
				index = 0;
			}
			if (index != 0)
			{
				return index;
			}
			List<int> list = new List<int>();
			foreach (int num in _serverMap[serverId])
			{
				MapInfo info = FindMapInfo(num);
				if ((type & info.Type) != 0)
				{
					list.Add(num);
				}
			}
			if (list.Count == 0)
			{
				int maxValue = _serverMap[serverId].Count;
				return _serverMap[serverId][random.Next(maxValue)];
			}
			int count = list.Count;
			return list[random.Next(count)];
        }

        public static MapPoint GetMapRandomPos(int index)
        {
			MapPoint point = new MapPoint();
			if (index != 0 && !_maps.Keys.Contains(index))
			{
				index = 0;
			}
			MapPoint point2;
			if (index == 0)
			{
				int[] numArray = _maps.Keys.ToArray();
				point2 = _maps[numArray[random.Next(numArray.Length)]];
			}
			else
			{
				point2 = _maps[index];
			}
			if (random.Next(2) == 1)
			{
				point.PosX.AddRange(point2.PosX);
				point.PosX1.AddRange(point2.PosX1);
				return point;
			}
			point.PosX.AddRange(point2.PosX1);
			point.PosX1.AddRange(point2.PosX);
			return point;
        }

        public static MapPoint GetPVEMapRandomPos(int index)
        {
			MapPoint mapPoint = new MapPoint();
			if (index != 0 && !_maps.Keys.Contains(index))
			{
				index = 0;
			}
			MapPoint point2;
			if (index == 0)
			{
				int[] numArray = _maps.Keys.ToArray();
				point2 = _maps[numArray[random.Next(numArray.Length)]];
			}
			else
			{
				point2 = _maps[index];
			}
			mapPoint.PosX.AddRange(point2.PosX);
			mapPoint.PosX1.AddRange(point2.PosX1);
			return mapPoint;
        }

        public static bool Init()
        {
			try
			{
				random = new ThreadSafeRandom();
				m_lock = new ReaderWriterLock();
				_maps = new Dictionary<int, MapPoint>();
				_mapInfos = new Dictionary<int, Map>();
				if (!LoadMap(_maps, _mapInfos))
				{
					return false;
				}
				_serverMap = new Dictionary<int, List<int>>();
				if (!InitServerMap(_serverMap))
				{
					return false;
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("MapMgr", exception);
				}
				return false;
			}
			return true;
        }

        public static bool InitServerMap(Dictionary<int, List<int>> servermap)
        {
			ServerMapInfo[] allServerMap = new MapBussiness().GetAllServerMap();
			try
			{
				int result = 0;
				ServerMapInfo[] array = allServerMap;
				ServerMapInfo[] array4 = array;
				foreach (ServerMapInfo info in array4)
				{
					if (servermap.Keys.Contains(info.ServerID))
					{
						continue;
					}
					string[] array2 = info.OpenMap.Split(',');
					List<int> list = new List<int>();
					string[] array3 = array2;
					string[] array5 = array3;
					foreach (string str in array5)
					{
						if (!string.IsNullOrEmpty(str) && int.TryParse(str, out result))
						{
							list.Add(result);
						}
					}
					servermap.Add(info.ServerID, list);
				}
			}
			catch (Exception exception)
			{
				log.Error(exception.ToString());
			}
			return true;
        }

        public static bool LoadMap(Dictionary<int, MapPoint> maps, Dictionary<int, Map> mapInfos)
        {
			try
			{
				MapInfo[] allMap = new MapBussiness().GetAllMap();
				MapInfo[] array2 = allMap;
				foreach (MapInfo info in array2)
				{
					if (string.IsNullOrEmpty(info.PosX))
					{
						continue;
					}
					if (!maps.Keys.Contains(info.ID))
					{
						string[] strArray = info.PosX.Split('|');
						string[] strArray2 = info.PosX1.Split('|');
						MapPoint point = new MapPoint();
						string[] array = strArray;
						string[] array3 = array;
						foreach (string str in array3)
						{
							if (!string.IsNullOrEmpty(str.Trim()))
							{
								string[] strArray3 = str.Split(',');
								point.PosX.Add(new Point(int.Parse(strArray3[0]), int.Parse(strArray3[1])));
							}
						}
						array = strArray2;
						string[] array4 = array;
						foreach (string str2 in array4)
						{
							if (!string.IsNullOrEmpty(str2.Trim()))
							{
								string[] strArray4 = str2.Split(',');
								point.PosX1.Add(new Point(int.Parse(strArray4[0]), int.Parse(strArray4[1])));
							}
						}
						maps.Add(info.ID, point);
					}
					if (!mapInfos.ContainsKey(info.ID))
					{
						Tile tile = null;
						string path = $"map\\{info.ID}\\fore.map";
						if (File.Exists(path))
						{
							tile = new Tile(path, digable: true);
						}
						Tile tile2 = null;
						path = $"map\\{info.ID}\\dead.map";
						if (File.Exists(path))
						{
							tile2 = new Tile(path, digable: false);
						}
						if (tile != null || tile2 != null)
						{
							mapInfos.Add(info.ID, new Map(info, tile, tile2));
						}
						else if (log.IsErrorEnabled)
						{
							log.Error("Map's file" + info.ID + " is not exist!");
						}
					}
				}
				if (maps.Count == 0 || mapInfos.Count == 0)
				{
					if (log.IsErrorEnabled)
					{
						log.Error("maps:" + maps.Count + ",mapInfos:" + mapInfos.Count);
					}
					return false;
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("MapMgr", exception);
				}
				return false;
			}
			return true;
        }

        public static bool ReLoadMap()
        {
			try
			{
				Dictionary<int, MapPoint> maps = new Dictionary<int, MapPoint>();
				Dictionary<int, Map> mapInfos = new Dictionary<int, Map>();
				if (LoadMap(maps, mapInfos))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_maps = maps;
						_mapInfos = mapInfos;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoadMap", exception);
				}
			}
			return false;
        }

        public static bool ReLoadMapServer()
        {
			try
			{
				Dictionary<int, List<int>> servermap = new Dictionary<int, List<int>>();
				if (InitServerMap(servermap))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_serverMap = servermap;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoadMapWeek", exception);
				}
			}
			return false;
        }
    }
}
