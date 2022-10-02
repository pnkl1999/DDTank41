using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Bussiness
{
    public class MapBussiness : BaseCrossBussiness
    {
        public MapInfo[] GetAllMap()
        {
			List<MapInfo> list = new List<MapInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Maps_All");
				while (resultDataReader.Read())
				{
					MapInfo item = new MapInfo
					{
						BackMusic = ((resultDataReader["BackMusic"] == null) ? "" : resultDataReader["BackMusic"].ToString()),
						BackPic = ((resultDataReader["BackPic"] == null) ? "" : resultDataReader["BackPic"].ToString()),
						BackroundHeight = (int)resultDataReader["BackroundHeight"],
						BackroundWidht = (int)resultDataReader["BackroundWidht"],
						DeadHeight = (int)resultDataReader["DeadHeight"],
						DeadPic = ((resultDataReader["DeadPic"] == null) ? "" : resultDataReader["DeadPic"].ToString()),
						DeadWidth = (int)resultDataReader["DeadWidth"],
						Description = ((resultDataReader["Description"] == null) ? "" : resultDataReader["Description"].ToString()),
						DragIndex = (int)resultDataReader["DragIndex"],
						ForegroundHeight = (int)resultDataReader["ForegroundHeight"],
						ForegroundWidth = (int)resultDataReader["ForegroundWidth"],
						ForePic = ((resultDataReader["ForePic"] == null) ? "" : resultDataReader["ForePic"].ToString()),
						ID = (int)resultDataReader["ID"],
						Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString()),
						Pic = ((resultDataReader["Pic"] == null) ? "" : resultDataReader["Pic"].ToString()),
						Remark = ((resultDataReader["Remark"] == null) ? "" : resultDataReader["Remark"].ToString()),
						Weight = (int)resultDataReader["Weight"],
						PosX = ((resultDataReader["PosX"] == null) ? "" : resultDataReader["PosX"].ToString()),
						PosX1 = ((resultDataReader["PosX1"] == null) ? "" : resultDataReader["PosX1"].ToString()),
						Type = (byte)(int)resultDataReader["Type"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllMap", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return list.ToArray();
        }

        public ServerMapInfo[] GetAllServerMap()
        {
			List<ServerMapInfo> list = new List<ServerMapInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Maps_Server_All");
				while (resultDataReader.Read())
				{
					ServerMapInfo item = new ServerMapInfo
					{
						ServerID = (int)resultDataReader["ServerID"],
						OpenMap = resultDataReader["OpenMap"].ToString(),
						IsSpecial = (int)resultDataReader["IsSpecial"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllMapWeek", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return list.ToArray();
        }
    }
}
