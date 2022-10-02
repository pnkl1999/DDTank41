using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Bussiness
{
    public class PveBussiness : BaseCrossBussiness
    {
        public PveInfo[] GetAllPveInfos()
        {
			List<PveInfo> list = new List<PveInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_PveInfos_All");
				while (resultDataReader.Read())
				{
					PveInfo pveInfo = new PveInfo();
					pveInfo.ID = (int)resultDataReader["Id"];
					pveInfo.Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString());
					pveInfo.Type = (int)resultDataReader["Type"];
					pveInfo.LevelLimits = (int)resultDataReader["LevelLimits"];
					pveInfo.SimpleTemplateIds = ((resultDataReader["SimpleTemplateIds"] == null) ? "" : resultDataReader["SimpleTemplateIds"].ToString());
					pveInfo.NormalTemplateIds = ((resultDataReader["NormalTemplateIds"] == null) ? "" : resultDataReader["NormalTemplateIds"].ToString());
					pveInfo.HardTemplateIds = ((resultDataReader["HardTemplateIds"] == null) ? "" : resultDataReader["HardTemplateIds"].ToString());
					pveInfo.TerrorTemplateIds = ((resultDataReader["TerrorTemplateIds"] == null) ? "" : resultDataReader["TerrorTemplateIds"].ToString());
					pveInfo.Pic = ((resultDataReader["Pic"] == null) ? "" : resultDataReader["Pic"].ToString());
					pveInfo.Description = ((resultDataReader["Description"] == null) ? "" : resultDataReader["Description"].ToString());
					pveInfo.Ordering = (int)resultDataReader["Ordering"];
					pveInfo.AdviceTips = ((resultDataReader["AdviceTips"] == null) ? "" : resultDataReader["AdviceTips"].ToString());
					pveInfo.SimpleGameScript = resultDataReader["SimpleGameScript"] as string;
					pveInfo.NormalGameScript = resultDataReader["NormalGameScript"] as string;
					pveInfo.HardGameScript = resultDataReader["HardGameScript"] as string;
					pveInfo.TerrorGameScript = resultDataReader["TerrorGameScript"] as string;
					pveInfo.BossFightNeedMoney = (resultDataReader["BossFightNeedMoney"] == null) ? "" : resultDataReader["BossFightNeedMoney"].ToString();
					pveInfo.LastFloor = (resultDataReader["LastFloor"] == null) ? "1,1,1,1" : resultDataReader["LastFloor"].ToString();
					PveInfo item = pveInfo;
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPveInfos", exception);
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
