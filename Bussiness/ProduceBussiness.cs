using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Bussiness
{
    public class ProduceBussiness : BaseCrossBussiness
    {
        public CardGroupInfo[] GetAllCardGroup()
        {
			List<CardGroupInfo> infos = new List<CardGroupInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Card_Group_All");
				while (reader.Read())
				{
					infos.Add(InitCardGroup(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCardGroup", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public CardGroupInfo InitCardGroup(SqlDataReader reader)
        {
			CardGroupInfo info = new CardGroupInfo();
			info.ID = (int)reader["ID"];
			info.CardID = (int)reader["CardID"];
			info.TemplateID = (int)reader["TemplateID"];
			return info;
        }

        public CardInfo[] GetAllCard()
        {
			List<CardInfo> infos = new List<CardInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Card_Info_All");
				while (reader.Read())
				{
					infos.Add(InitCard(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCard", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public CardInfo InitCard(SqlDataReader reader)
        {
			CardInfo info = new CardInfo();
			info.ID = (int)reader["ID"];
			info.SuitID = (int)reader["SuitID"];
			info.Name = ((reader["Name"] == null) ? "" : reader["Name"].ToString());
			info.Description = ((reader["Description"] == null) ? "" : reader["Description"].ToString());
			return info;
        }

        public CardBuffInfo[] GetAllCardBuff()
        {
			List<CardBuffInfo> infos = new List<CardBuffInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Card_Buff_All");
				while (reader.Read())
				{
					infos.Add(InitCardBuff(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCardBuff", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public CardBuffInfo InitCardBuff(SqlDataReader reader)
        {
			CardBuffInfo info = new CardBuffInfo();
			info.ID = (int)reader["ID"];
			info.CardID = (int)reader["CardID"];
			info.Condition = (int)reader["condition"];
			info.PropertiesDscripID = (int)reader["PropertiesDscripID"];
			info.Value = ((reader["value"] == null) ? "" : reader["value"].ToString());
			info.Description = ((reader["Description"] == null) ? "" : reader["Description"].ToString());
			return info;
        }

        public ActiveAwardInfo[] GetAllActiveAwardInfo()
        {
			List<ActiveAwardInfo> list = new List<ActiveAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Active_Award");
				while (resultDataReader.Read())
				{
					ActiveAwardInfo item = new ActiveAwardInfo
					{
						ID = (int)resultDataReader["ID"],
						ActiveID = (int)resultDataReader["ActiveID"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						Count = (int)resultDataReader["Count"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						Gold = (int)resultDataReader["Gold"],
						ItemID = (int)resultDataReader["ItemID"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						Mark = (int)resultDataReader["Mark"],
						Money = (int)resultDataReader["Money"],
						Sex = (int)resultDataReader["Sex"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						ValidDate = (int)resultDataReader["ValidDate"],
						GiftToken = (int)resultDataReader["GiftToken"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllActiveAwardInfo", exception);
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

        public ActiveConditionInfo[] GetAllActiveConditionInfo()
        {
			List<ActiveConditionInfo> list = new List<ActiveConditionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Active_Condition");
				while (resultDataReader.Read())
				{
					ActiveConditionInfo item = new ActiveConditionInfo
					{
						ID = (int)resultDataReader["ID"],
						ActiveID = (int)resultDataReader["ActiveID"],
						Conditiontype = (int)resultDataReader["Conditiontype"],
						Condition = (int)resultDataReader["Condition"],
						LimitGrade = ((resultDataReader["LimitGrade"].ToString() == null) ? "" : resultDataReader["LimitGrade"].ToString()),
						AwardId = ((resultDataReader["AwardId"].ToString() == null) ? "" : resultDataReader["AwardId"].ToString()),
						IsMult = (bool)resultDataReader["IsMult"],
						StartTime = (DateTime)resultDataReader["StartTime"],
						EndTime = (DateTime)resultDataReader["EndTime"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllActiveConditionInfo", exception);
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

        public AchievementInfo[] GetAllAchievement()
        {
			List<AchievementInfo> list = new List<AchievementInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_Achievement");
				while (resultDataReader.Read())
				{
					AchievementInfo item = new AchievementInfo
					{
						ID = (int)resultDataReader["ID"],
						PlaceID = (int)resultDataReader["PlaceID"],
						Title = (string)resultDataReader["Title"],
						Detail = (string)resultDataReader["Detail"],
						NeedMinLevel = (int)resultDataReader["NeedMinLevel"],
						NeedMaxLevel = (int)resultDataReader["NeedMaxLevel"],
						PreAchievementID = (string)resultDataReader["PreAchievementID"],
						IsOther = (int)resultDataReader["IsOther"],
						AchievementType = (int)resultDataReader["AchievementType"],
						CanHide = (bool)resultDataReader["CanHide"],
						StartDate = (DateTime)resultDataReader["StartDate"],
						EndDate = (DateTime)resultDataReader["EndDate"],
						AchievementPoint = (int)resultDataReader["AchievementPoint"],
						IsActive = (int)resultDataReader["IsActive"],
						PicID = (int)resultDataReader["PicID"],
						IsShare = (bool)resultDataReader["IsShare"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public AchievementInfo[] GetALlAchievement()
        {
			List<AchievementInfo> list = new List<AchievementInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Achievement_All");
				while (resultDataReader.Read())
				{
					list.Add(InitAchievement(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetALlAchievement:", exception);
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

        public AchievementCondictionInfo[] GetAllAchievementCondiction()
        {
			List<AchievementCondictionInfo> list = new List<AchievementCondictionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_AchievementCondiction");
				while (resultDataReader.Read())
				{
					AchievementCondictionInfo item = new AchievementCondictionInfo
					{
						AchievementID = (int)resultDataReader["AchievementID"],
						CondictionID = (int)resultDataReader["CondictionID"],
						CondictionType = (int)resultDataReader["CondictionType"],
						Condiction_Para1 = (int)resultDataReader["Condiction_Para1"],
						Condiction_Para2 = (int)resultDataReader["Condiction_Para2"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public AchievementConditionInfo[] GetALlAchievementCondition()
        {
			List<AchievementConditionInfo> list = new List<AchievementConditionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Achievement_Condition_All");
				while (resultDataReader.Read())
				{
					list.Add(InitAchievementCondition(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetALlAchievementCondition:", exception);
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

        public AchievementGoodsInfo[] GetAllAchievementGoods()
        {
			List<AchievementGoodsInfo> list = new List<AchievementGoodsInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_AchievementGoods");
				while (resultDataReader.Read())
				{
					AchievementGoodsInfo item = new AchievementGoodsInfo
					{
						AchievementID = (int)resultDataReader["AchievementID"],
						RewardType = (int)resultDataReader["RewardType"],
						RewardPara = (string)resultDataReader["RewardPara"],
						RewardValueId = (int)resultDataReader["RewardValueId"],
						RewardCount = (int)resultDataReader["RewardCount"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public AchievementRewardInfo[] GetALlAchievementReward()
        {
			List<AchievementRewardInfo> list = new List<AchievementRewardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Achievement_Reward_All");
				while (resultDataReader.Read())
				{
					list.Add(InitAchievementReward(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetALlAchievementReward", exception);
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

        public BallInfo[] GetAllBall()
        {
			List<BallInfo> list = new List<BallInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Ball_All");
				while (resultDataReader.Read())
				{
					BallInfo item = new BallInfo
					{
						Amount = (int)resultDataReader["Amount"],
						ID = (int)resultDataReader["ID"],
						Name = resultDataReader["Name"].ToString(),
						Crater = ((resultDataReader["Crater"] == null) ? "" : resultDataReader["Crater"].ToString()),
						Power = (double)resultDataReader["Power"],
						Radii = (int)resultDataReader["Radii"],
						AttackResponse = (int)resultDataReader["AttackResponse"],
						BombPartical = resultDataReader["BombPartical"].ToString(),
						FlyingPartical = resultDataReader["FlyingPartical"].ToString(),
						IsSpin = (bool)resultDataReader["IsSpin"],
						Mass = (int)resultDataReader["Mass"],
						SpinV = (int)resultDataReader["SpinV"],
						SpinVA = (double)resultDataReader["SpinVA"],
						Wind = (int)resultDataReader["Wind"],
						DragIndex = (int)resultDataReader["DragIndex"],
						Weight = (int)resultDataReader["Weight"],
						Shake = (bool)resultDataReader["Shake"],
						Delay = (int)resultDataReader["Delay"],
						ShootSound = ((resultDataReader["ShootSound"] == null) ? "" : resultDataReader["ShootSound"].ToString()),
						BombSound = ((resultDataReader["BombSound"] == null) ? "" : resultDataReader["BombSound"].ToString()),
						ActionType = (int)resultDataReader["ActionType"],
						HasTunnel = (bool)resultDataReader["HasTunnel"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public ItemTemplateInfo[] GetSingleName(string ItemName)
        {
			List<ItemTemplateInfo> infos = new List<ItemTemplateInfo>();
			SqlDataReader reader = null;
			try
			{
				SqlParameter[] para = new SqlParameter[1]
				{
					new SqlParameter("@name", SqlDbType.NVarChar, 100)
				};
				para[0].Value = ItemName;
				db.GetReader(ref reader, "SP_Items_Name_Single", para);
				while (reader.Read())
				{
					infos.Add(InitItemTemplateInfo(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public BallConfigInfo[] GetAllBallConfig()
        {
			List<BallConfigInfo> list = new List<BallConfigInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "[SP_Ball_Config_All]");
				while (resultDataReader.Read())
				{
					BallConfigInfo item = new BallConfigInfo
					{
						Common = (int)resultDataReader["Common"],
						TemplateID = (int)resultDataReader["TemplateID"],
						CommonAddWound = (int)resultDataReader["CommonAddWound"],
						CommonMultiBall = (int)resultDataReader["CommonMultiBall"],
						Special = (int)resultDataReader["Special"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public CategoryInfo[] GetAllCategory()
        {
			List<CategoryInfo> list = new List<CategoryInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Items_Category_All");
				while (resultDataReader.Read())
				{
					CategoryInfo item = new CategoryInfo
					{
						ID = (int)resultDataReader["ID"],
						Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString()),
						Place = (int)resultDataReader["Place"],
						Remark = ((resultDataReader["Remark"] == null) ? "" : resultDataReader["Remark"].ToString())
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public DailyAwardInfo[] GetAllDailyAward()
        {
			List<DailyAwardInfo> list = new List<DailyAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Daily_Award_All");
				while (resultDataReader.Read())
				{
					DailyAwardInfo item = new DailyAwardInfo
					{
						Count = (int)resultDataReader["Count"],
						ID = (int)resultDataReader["ID"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						TemplateID = (int)resultDataReader["TemplateID"],
						Type = (int)resultDataReader["Type"],
						ValidDate = (int)resultDataReader["ValidDate"],
						Sex = (int)resultDataReader["Sex"],
						Remark = ((resultDataReader["Remark"] == null) ? "" : resultDataReader["Remark"].ToString()),
						CountRemark = ((resultDataReader["CountRemark"] == null) ? "" : resultDataReader["CountRemark"].ToString()),
						GetWay = (int)resultDataReader["GetWay"],
						AwardDays = (int)resultDataReader["AwardDays"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllDaily", exception);
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

        public DailyAwardInfo[] GetSingleDailyAward(int awardDays)
        {
			List<DailyAwardInfo> list = new List<DailyAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@awardDays", awardDays)
				};
				db.GetReader(ref resultDataReader, "SP_Daily_Award_Single", sqlParameters);
				while (resultDataReader.Read())
				{
					DailyAwardInfo item = new DailyAwardInfo
					{
						Count = (int)resultDataReader["Count"],
						ID = (int)resultDataReader["ID"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						TemplateID = (int)resultDataReader["TemplateID"],
						Type = (int)resultDataReader["Type"],
						ValidDate = (int)resultDataReader["ValidDate"],
						Sex = (int)resultDataReader["Sex"],
						Remark = ((resultDataReader["Remark"] == null) ? "" : resultDataReader["Remark"].ToString()),
						CountRemark = ((resultDataReader["CountRemark"] == null) ? "" : resultDataReader["CountRemark"].ToString()),
						GetWay = (int)resultDataReader["GetWay"],
						AwardDays = (int)resultDataReader["AwardDays"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetSingleDaily", exception);
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

        public DropCondiction[] GetAllDropCondictions()
        {
			List<DropCondiction> list = new List<DropCondiction>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Drop_Condiction_All");
				while (resultDataReader.Read())
				{
					list.Add(InitDropCondiction(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public DropItem[] GetAllDropItems()
        {
			List<DropItem> list = new List<DropItem>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Drop_Item_All");
				while (resultDataReader.Read())
				{
					list.Add(InitDropItem(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public EdictumInfo[] GetAllEdictum()
        {
			List<EdictumInfo> list = new List<EdictumInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Edictum_All");
				while (resultDataReader.Read())
				{
					list.Add(InitEdictum(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllEdictum", exception);
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

        public EventRewardGoodsInfo[] GetAllEventRewardGoods()
        {
			List<EventRewardGoodsInfo> list = new List<EventRewardGoodsInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_EventRewardGoods");
				while (resultDataReader.Read())
				{
					EventRewardGoodsInfo item = new EventRewardGoodsInfo
					{
						ActivityType = (int)resultDataReader["ActivityType"],
						SubActivityType = (int)resultDataReader["SubActivityType"],
						TemplateId = (int)resultDataReader["TemplateId"],
						StrengthLevel = (int)resultDataReader["StrengthLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						IsBind = (bool)resultDataReader["IsBind"],
						ValidDate = (int)resultDataReader["ValidDate"],
						Count = (int)resultDataReader["Count"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllEventRewardGoods", exception);
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

        public EventRewardGoodsInfo[] GetEventRewardGoodsByType(int ActivityType, int SubActivityType)
        {
			List<EventRewardGoodsInfo> list = new List<EventRewardGoodsInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@ActivityType", ActivityType),
					new SqlParameter("@SubActivityType", SubActivityType)
				};
				db.GetReader(ref resultDataReader, "SP_Get_EventRewardGoods_Type", sqlParameters);
				while (resultDataReader.Read())
				{
					EventRewardGoodsInfo item = new EventRewardGoodsInfo
					{
						ActivityType = (int)resultDataReader["ActivityType"],
						SubActivityType = (int)resultDataReader["SubActivityType"],
						TemplateId = (int)resultDataReader["TemplateId"],
						StrengthLevel = (int)resultDataReader["StrengthLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						IsBind = (bool)resultDataReader["IsBind"],
						ValidDate = (int)resultDataReader["ValidDate"],
						Count = (int)resultDataReader["Count"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetEventRewardGoodsByType", exception);
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

        public EventRewardInfo[] GetAllEventRewardInfo()
        {
			List<EventRewardInfo> list = new List<EventRewardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_EventRewardInfo");
				while (resultDataReader.Read())
				{
					EventRewardInfo item = new EventRewardInfo
					{
						ActivityType = (int)resultDataReader["ActivityType"],
						SubActivityType = (int)resultDataReader["SubActivityType"],
						Condition = (int)resultDataReader["Condition"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllEventRewardInfo", exception);
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

        public EventRewardInfo[] GetEventRewardInfoByType(int ActivityType, int SubActivityType)
        {
			List<EventRewardInfo> list = new List<EventRewardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[2]
				{
					new SqlParameter("@ActivityType", ActivityType),
					new SqlParameter("@SubActivityType", SubActivityType)
				};
				db.GetReader(ref resultDataReader, "SP_Get_EventRewardInfo_Type", sqlParameters);
				while (resultDataReader.Read())
				{
					EventRewardInfo item = new EventRewardInfo
					{
						ActivityType = (int)resultDataReader["ActivityType"],
						SubActivityType = (int)resultDataReader["SubActivityType"],
						Condition = (int)resultDataReader["Condition"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetEventRewardInfoByType", exception);
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

		public FusionInfo[] GetAllFusion()
		{
			List<FusionInfo> fusionInfoList = new List<FusionInfo>();
			SqlDataReader ResultDataReader = (SqlDataReader)null;
			try
			{
				this.db.GetReader(ref ResultDataReader, "SP_Fusion_All");
				while (ResultDataReader.Read())
					fusionInfoList.Add(new FusionInfo()
					{
						FusionID = (int)ResultDataReader["FusionID"],
						Item1 = (int)ResultDataReader["Item1"],
						Item2 = (int)ResultDataReader["Item2"],
						Item3 = (int)ResultDataReader["Item3"],
						Item4 = (int)ResultDataReader["Item4"],
						Formula = (int)ResultDataReader["Formula"],
						Reward = (int)ResultDataReader["Reward"]
					});
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
					log.Error((object)nameof(GetAllFusion), ex);
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
					ResultDataReader.Close();
			}
			return fusionInfoList.ToArray();
		}

		public FusionInfo[] GetAllFusionDesc()
        {
			List<FusionInfo> list = new List<FusionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Fusion_All_Desc");
				while (resultDataReader.Read())
				{
					FusionInfo item = new FusionInfo
					{
						FusionID = (int)resultDataReader["FusionID"],
						Item1 = (int)resultDataReader["Item1"],
						Item2 = (int)resultDataReader["Item2"],
						Item3 = (int)resultDataReader["Item3"],
						Item4 = (int)resultDataReader["Item4"],
						Formula = (int)resultDataReader["Formula"],
						Reward = (int)resultDataReader["Reward"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllFusion", exception);
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

        public Items_Fusion_List_Info[] GetAllFusionList()
        {
			List<Items_Fusion_List_Info> list = new List<Items_Fusion_List_Info>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "GET_ItemFusion_All");
				while (resultDataReader.Read())
				{
					Items_Fusion_List_Info item = new Items_Fusion_List_Info
					{
						ID = (int)resultDataReader["ID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						Show = (int)resultDataReader["Show"],
						Real = (int)resultDataReader["Real"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GET_ItemFusion_All", exception);
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

        public ItemTemplateInfo[] GetAllGoods()
        {
			List<ItemTemplateInfo> list = new List<ItemTemplateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Items_All");
				while (resultDataReader.Read())
				{
					list.Add(InitItemTemplateInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public ItemTemplateInfo[] GetAllGoodsASC()
        {
			List<ItemTemplateInfo> list = new List<ItemTemplateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Items_All_ASC");
				while (resultDataReader.Read())
				{
					list.Add(InitItemTemplateInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public HotSpringRoomInfo[] GetAllHotSpringRooms()
        {
			List<HotSpringRoomInfo> list = new List<HotSpringRoomInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_HotSpring_Room");
				while (resultDataReader.Read())
				{
					HotSpringRoomInfo item = new HotSpringRoomInfo
					{
						roomID = (int)resultDataReader["roomID"],
						roomNumber = (int)resultDataReader["roomNumber"],
						roomName = resultDataReader["roomName"].ToString(),
						roomPassword = ((resultDataReader["roomPassword"] == DBNull.Value) ? null : ((string)resultDataReader["roomPassword"])),
						effectiveTime = (int)resultDataReader["effectiveTime"],
						curCount = (int)resultDataReader["curCount"],
						playerID = (int)resultDataReader["playerID"],
						playerName = (string)resultDataReader["playerName"],
						startTime = ((resultDataReader["startTime"] == DBNull.Value) ? DateTime.Now : ((DateTime)resultDataReader["startTime"])),
						endTime = ((resultDataReader["endTime"] == DBNull.Value) ? DateTime.Now.AddYears(1) : ((DateTime)resultDataReader["endTime"])),
						roomIntroduction = ((resultDataReader["roomIntroduction"] == DBNull.Value) ? "" : ((string)resultDataReader["roomIntroduction"])),
						roomType = (int)resultDataReader["roomType"],
						maxCount = (int)resultDataReader["maxCount"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllHotSpringRooms", exception);
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

        public ItemRecordTypeInfo[] GetAllItemRecordType()
        {
			List<ItemRecordTypeInfo> list = new List<ItemRecordTypeInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Item_Record_Type_All");
				while (resultDataReader.Read())
				{
					list.Add(InitItemRecordType(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllItemRecordType:", exception);
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

		//     public ShopItemInfo[] GetALllShop()
		//     {
		//List<ShopItemInfo> list = new List<ShopItemInfo>();
		//SqlDataReader resultDataReader = null;
		//try
		//{
		//	db.GetReader(ref resultDataReader, "SP_Shop_All");
		//	while (resultDataReader.Read())
		//	{
		//		ShopItemInfo item = new ShopItemInfo
		//		{
		//			ID = int.Parse(resultDataReader["ID"].ToString()),
		//			ShopID = int.Parse(resultDataReader["ShopID"].ToString()),
		//			GroupID = int.Parse(resultDataReader["GroupID"].ToString()),
		//			TemplateID = int.Parse(resultDataReader["TemplateID"].ToString()),
		//			BuyType = int.Parse(resultDataReader["BuyType"].ToString()),
		//			Sort = 0,
		//			IsVouch = int.Parse(resultDataReader["IsVouch"].ToString()),
		//			Label = int.Parse(resultDataReader["Label"].ToString()),
		//			Beat = decimal.Parse(resultDataReader["Beat"].ToString()),
		//			AUnit = int.Parse(resultDataReader["AUnit"].ToString()),
		//			APrice1 = int.Parse(resultDataReader["APrice1"].ToString()),
		//			AValue1 = int.Parse(resultDataReader["AValue1"].ToString()),
		//			APrice2 = int.Parse(resultDataReader["APrice2"].ToString()),
		//			AValue2 = int.Parse(resultDataReader["AValue2"].ToString()),
		//			APrice3 = int.Parse(resultDataReader["APrice3"].ToString()),
		//			AValue3 = int.Parse(resultDataReader["AValue3"].ToString()),
		//			BUnit = int.Parse(resultDataReader["BUnit"].ToString()),
		//			BPrice1 = int.Parse(resultDataReader["BPrice1"].ToString()),
		//			BValue1 = int.Parse(resultDataReader["BValue1"].ToString()),
		//			BPrice2 = int.Parse(resultDataReader["BPrice2"].ToString()),
		//			BValue2 = int.Parse(resultDataReader["BValue2"].ToString()),
		//			BPrice3 = int.Parse(resultDataReader["BPrice3"].ToString()),
		//			BValue3 = int.Parse(resultDataReader["BValue3"].ToString()),
		//			CUnit = int.Parse(resultDataReader["CUnit"].ToString()),
		//			CPrice1 = int.Parse(resultDataReader["CPrice1"].ToString()),
		//			CValue1 = int.Parse(resultDataReader["CValue1"].ToString()),
		//			CPrice2 = int.Parse(resultDataReader["CPrice2"].ToString()),
		//			CValue2 = int.Parse(resultDataReader["CValue2"].ToString()),
		//			CPrice3 = int.Parse(resultDataReader["CPrice3"].ToString()),
		//			CValue3 = int.Parse(resultDataReader["CValue3"].ToString()),
		//			IsContinue = bool.Parse(resultDataReader["IsContinue"].ToString()),
		//			IsCheap = bool.Parse(resultDataReader["IsCheap"].ToString()),
		//			LimitCount = int.Parse(resultDataReader["LimitCount"].ToString()),
		//			StartDate = DateTime.Parse(resultDataReader["StartDate"].ToString()),
		//			EndDate = DateTime.Parse(resultDataReader["EndDate"].ToString())
		//		};
		//		list.Add(item);
		//	}
		//}
		//catch (Exception exception)
		//{
		//	if (log.IsErrorEnabled)
		//	{
		//		log.Error("Init", exception);
		//	}
		//}
		//finally
		//{
		//	if (resultDataReader != null && !resultDataReader.IsClosed)
		//	{
		//		resultDataReader.Close();
		//	}
		//}
		//return list.ToArray();
		//     }

		public ShopItemInfo[] GetALllShop()
		{
			List<ShopItemInfo> infos = new List<ShopItemInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Shop_All");
				while (reader.Read())
				{
					ShopItemInfo info = new ShopItemInfo();
					info.ID = int.Parse(reader["ID"].ToString());
					info.ShopID = int.Parse(reader["ShopID"].ToString());
					info.GroupID = int.Parse(reader["GroupID"].ToString());
					info.TemplateID = int.Parse(reader["TemplateID"].ToString());
					info.BuyType = int.Parse(reader["BuyType"].ToString());
					info.Sort = 0;
					//info.IsVouch = int.Parse(reader["IsVouch"].ToString());
					info.IsVouch = (reader["IsVouch"] == null) ? 0 : int.Parse(reader["IsVouch"].ToString());
					info.Label = int.Parse(reader["Label"].ToString());
					info.Beat = decimal.Parse(reader["Beat"].ToString());

					info.AUnit = int.Parse(reader["AUnit"].ToString());
					info.APrice1 = int.Parse(reader["APrice1"].ToString());
					info.AValue1 = int.Parse(reader["AValue1"].ToString());
					info.APrice2 = int.Parse(reader["APrice2"].ToString());
					info.AValue2 = int.Parse(reader["AValue2"].ToString());
					info.APrice3 = int.Parse(reader["APrice3"].ToString());
					info.AValue3 = int.Parse(reader["AValue3"].ToString());

					info.BUnit = int.Parse(reader["BUnit"].ToString());
					info.BPrice1 = int.Parse(reader["BPrice1"].ToString());
					info.BValue1 = int.Parse(reader["BValue1"].ToString());
					info.BPrice2 = int.Parse(reader["BPrice2"].ToString());
					info.BValue2 = int.Parse(reader["BValue2"].ToString());
					info.BPrice3 = int.Parse(reader["BPrice3"].ToString());
					info.BValue3 = int.Parse(reader["BValue3"].ToString());

					info.CUnit = int.Parse(reader["CUnit"].ToString());
					info.CPrice1 = int.Parse(reader["CPrice1"].ToString());
					info.CValue1 = int.Parse(reader["CValue1"].ToString());
					info.CPrice2 = int.Parse(reader["CPrice2"].ToString());
					info.CValue2 = int.Parse(reader["CValue2"].ToString());
					info.CPrice3 = int.Parse(reader["CPrice3"].ToString());
					info.CValue3 = int.Parse(reader["CValue3"].ToString());

					info.IsBind = int.Parse(reader["IsBind"].ToString());
					info.IsContinue = bool.Parse(reader["IsContinue"].ToString());
					info.IsCheap = bool.Parse(reader["IsCheap"].ToString());
					info.LimitCount = int.Parse(reader["LimitCount"].ToString());
					info.StartDate = DateTime.Parse(reader["StartDate"].ToString());
					info.EndDate = DateTime.Parse(reader["EndDate"].ToString());
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("Init", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}

		public MissionInfo[] GetAllMissionInfo()
        {
			List<MissionInfo> list = new List<MissionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Mission_Info_All");
				while (resultDataReader.Read())
				{
					MissionInfo item = new MissionInfo
					{
						Id = (int)resultDataReader["ID"],
						Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString()),
						TotalCount = (int)resultDataReader["TotalCount"],
						TotalTurn = (int)resultDataReader["TotalTurn"],
						Script = ((resultDataReader["Script"] == null) ? "" : resultDataReader["Script"].ToString()),
						Success = ((resultDataReader["Success"] == null) ? "" : resultDataReader["Success"].ToString()),
						Failure = ((resultDataReader["Failure"] == null) ? "" : resultDataReader["Failure"].ToString()),
						Description = ((resultDataReader["Description"] == null) ? "" : resultDataReader["Description"].ToString()),
						IncrementDelay = (int)resultDataReader["IncrementDelay"],
						Delay = (int)resultDataReader["Delay"],
						Title = ((resultDataReader["Title"] == null) ? "" : resultDataReader["Title"].ToString()),
						Param1 = (int)resultDataReader["Param1"],
						Param2 = (int)resultDataReader["Param2"],
						TryAgain = (bool)resultDataReader["TryAgain"], 
						TryAgainCost = (int)resultDataReader["TryAgainCost"] 
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllMissionInfo", exception);
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

        public NpcInfo[] GetAllNPCInfo()
        {
			List<NpcInfo> list = new List<NpcInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_NPC_Info_All");
				while (resultDataReader.Read())
				{
					NpcInfo item = new NpcInfo
					{
						ID = (int)resultDataReader["ID"],
						Name = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString()),
						Level = (int)resultDataReader["Level"],
						Camp = (int)resultDataReader["Camp"],
						Type = (int)resultDataReader["Type"],
						Blood = (int)resultDataReader["Blood"],
						X = (int)resultDataReader["X"],
						Y = (int)resultDataReader["Y"],
						Width = (int)resultDataReader["Width"],
						Height = (int)resultDataReader["Height"],
						MoveMin = (int)resultDataReader["MoveMin"],
						MoveMax = (int)resultDataReader["MoveMax"],
						BaseDamage = (int)resultDataReader["BaseDamage"],
						BaseGuard = (int)resultDataReader["BaseGuard"],
						Attack = (int)resultDataReader["Attack"],
						Defence = (int)resultDataReader["Defence"],
						Agility = (int)resultDataReader["Agility"],
						Lucky = (int)resultDataReader["Lucky"],
						ModelID = ((resultDataReader["ModelID"] == null) ? "" : resultDataReader["ModelID"].ToString()),
						ResourcesPath = ((resultDataReader["ResourcesPath"] == null) ? "" : resultDataReader["ResourcesPath"].ToString()),
						DropRate = ((resultDataReader["DropRate"] == null) ? "" : resultDataReader["DropRate"].ToString()),
						Experience = (int)resultDataReader["Experience"],
						Delay = (int)resultDataReader["Delay"],
						Immunity = (int)resultDataReader["Immunity"],
						Alert = (int)resultDataReader["Alert"],
						Range = (int)resultDataReader["Range"],
						Preserve = (int)resultDataReader["Preserve"],
						Script = ((resultDataReader["Script"] == null) ? "" : resultDataReader["Script"].ToString()),
						FireX = (int)resultDataReader["FireX"],
						FireY = (int)resultDataReader["FireY"],
						DropId = (int)resultDataReader["DropId"],
						CurrentBallId = (int)resultDataReader["CurrentBallId"],
						speed = (int)resultDataReader["speed"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllNPCInfo", exception);
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

        public PropInfo[] GetAllProp()
        {
			List<PropInfo> list = new List<PropInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Prop_All");
				while (resultDataReader.Read())
				{
					PropInfo item = new PropInfo
					{
						AffectArea = (int)resultDataReader["AffectArea"],
						AffectTimes = (int)resultDataReader["AffectTimes"],
						AttackTimes = (int)resultDataReader["AttackTimes"],
						BoutTimes = (int)resultDataReader["BoutTimes"],
						BuyGold = (int)resultDataReader["BuyGold"],
						BuyMoney = (int)resultDataReader["BuyMoney"],
						Category = (int)resultDataReader["Category"],
						Delay = (int)resultDataReader["Delay"],
						Description = resultDataReader["Description"].ToString(),
						Icon = resultDataReader["Icon"].ToString(),
						ID = (int)resultDataReader["ID"],
						Name = resultDataReader["Name"].ToString(),
						Parameter = (int)resultDataReader["Parameter"],
						Pic = resultDataReader["Pic"].ToString(),
						Property1 = (int)resultDataReader["Property1"],
						Property2 = (int)resultDataReader["Property2"],
						Property3 = (int)resultDataReader["Property3"],
						Random = (int)resultDataReader["Random"],
						Script = resultDataReader["Script"].ToString()
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public QQtipsMessagesInfo[] GetAllQQtipsMessagesLoad()
        {
			List<QQtipsMessagesInfo> list = new List<QQtipsMessagesInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_QQtipsMessages_All");
				while (resultDataReader.Read())
				{
					list.Add(InitQQtipsMessagesLoad(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllQQtipsMessagesLoad", exception);
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

        public QuestInfo[] GetALlQuest()
        {
			List<QuestInfo> list = new List<QuestInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Quest_All");
				while (resultDataReader.Read())
				{
					list.Add(InitQuest(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public EventLiveInfo[] GetAllEventLive()
        {
			List<EventLiveInfo> list = new List<EventLiveInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Event_Live_All");
				while (resultDataReader.Read())
				{
					list.Add(InitEventLiveInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public QuestConditionInfo[] GetAllQuestCondiction()
        {
			List<QuestConditionInfo> list = new List<QuestConditionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Quest_Condiction_All");
				while (resultDataReader.Read())
				{
					list.Add(InitQuestCondiction(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public QuestRateInfo[] GetAllQuestRate()
        {
			List<QuestRateInfo> list = new List<QuestRateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Quest_Rate_All");
				while (resultDataReader.Read())
				{
					list.Add(InitQuestRate(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public QuestAwardInfo[] GetAllQuestGoods()
        {
			List<QuestAwardInfo> list = new List<QuestAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Quest_Goods_All");
				while (resultDataReader.Read())
				{
					list.Add(InitQuestGoods(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public EventLiveGoods[] GetAllEventLiveGoods()
        {
			List<EventLiveGoods> list = new List<EventLiveGoods>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Event_LiveGoods_All");
				while (resultDataReader.Read())
				{
					list.Add(InitEventLiveGoods(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public List<RefineryInfo> GetAllRefineryInfo()
        {
			List<RefineryInfo> list = new List<RefineryInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Item_Refinery_All");
				while (resultDataReader.Read())
				{
					RefineryInfo item = new RefineryInfo
					{
						RefineryID = (int)resultDataReader["RefineryID"]
					};
					item.m_Equip.Add((int)resultDataReader["Equip1"]);
					item.m_Equip.Add((int)resultDataReader["Equip2"]);
					item.m_Equip.Add((int)resultDataReader["Equip3"]);
					item.m_Equip.Add((int)resultDataReader["Equip4"]);
					item.Item1 = (int)resultDataReader["Item1"];
					item.Item2 = (int)resultDataReader["Item2"];
					item.Item3 = (int)resultDataReader["Item3"];
					item.Item1Count = (int)resultDataReader["Item1Count"];
					item.Item2Count = (int)resultDataReader["Item2Count"];
					item.Item3Count = (int)resultDataReader["Item3Count"];
					item.m_Reward.Add((int)resultDataReader["Material1"]);
					item.m_Reward.Add((int)resultDataReader["Operate1"]);
					item.m_Reward.Add((int)resultDataReader["Reward1"]);
					item.m_Reward.Add((int)resultDataReader["Material2"]);
					item.m_Reward.Add((int)resultDataReader["Operate2"]);
					item.m_Reward.Add((int)resultDataReader["Reward2"]);
					item.m_Reward.Add((int)resultDataReader["Material3"]);
					item.m_Reward.Add((int)resultDataReader["Operate3"]);
					item.m_Reward.Add((int)resultDataReader["Reward3"]);
					item.m_Reward.Add((int)resultDataReader["Material4"]);
					item.m_Reward.Add((int)resultDataReader["Operate4"]);
					item.m_Reward.Add((int)resultDataReader["Reward4"]);
					list.Add(item);
				}
				return list;
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllRefineryInfo", exception);
					return list;
				}
				return list;
			}
			finally
			{
				if (resultDataReader?.IsClosed ?? false)
				{
					resultDataReader.Close();
				}
			}
        }

        public StrengthenInfo[] GetAllRefineryStrengthen()
        {
			List<StrengthenInfo> list = new List<StrengthenInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Item_Refinery_Strengthen_All");
				while (resultDataReader.Read())
				{
					StrengthenInfo item = new StrengthenInfo
					{
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						Rock = (int)resultDataReader["Rock"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllRefineryStrengthen", exception);
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

        public SearchGoodsTempInfo[] GetAllSearchGoodsTemp()
        {
			List<SearchGoodsTempInfo> list = new List<SearchGoodsTempInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_SearchGoodsTemp_All");
				while (resultDataReader.Read())
				{
					SearchGoodsTempInfo item = new SearchGoodsTempInfo
					{
						StarID = (int)resultDataReader["StarID"],
						NeedMoney = (int)resultDataReader["NeedMoney"],
						DestinationReward = (int)resultDataReader["DestinationReward"],
						VIPLevel = (int)resultDataReader["VIPLevel"],
						ExtractNumber = ((resultDataReader["ExtractNumber"] == null) ? "" : resultDataReader["ExtractNumber"].ToString())
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllDaily", exception);
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

        public ShopGoodsShowListInfo[] GetAllShopGoodsShowList()
        {
			List<ShopGoodsShowListInfo> list = new List<ShopGoodsShowListInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_ShopGoodsShowList_All");
				while (resultDataReader.Read())
				{
					list.Add(InitShopGoodsShowListInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public StrengthenInfo[] GetAllStrengthen()
        {
			List<StrengthenInfo> list = new List<StrengthenInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Item_Strengthen_All");
				while (resultDataReader.Read())
				{
					StrengthenInfo item = new StrengthenInfo
					{
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						Rock = (int)resultDataReader["Rock"],
						Rock1 = (int)resultDataReader["Rock1"],
						Rock2 = (int)resultDataReader["Rock2"],
						Rock3 = (int)resultDataReader["Rock3"],
						StoneLevelMin = (int)resultDataReader["StoneLevelMin"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllStrengthen", exception);
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

		public StrengThenExpInfo[] GetAllStrengThenExp()
		{
			List<StrengThenExpInfo> infos = new List<StrengThenExpInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_StrengThenExp_All");
				while (reader.Read())
				{
					StrengThenExpInfo info = new StrengThenExpInfo();
					info.ID = (int)reader["ID"];
					info.Level = (int)reader["Level"];
					info.Exp = (int)reader["Exp"];
					info.NecklaceStrengthExp = (int)reader["NecklaceStrengthExp"];
					info.NecklaceStrengthPlus = (int)reader["NecklaceStrengthPlus"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("GetStrengThenExpInfo", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}

		public StrengthenGoodsInfo[] GetAllStrengthenGoodsInfo()
        {
			List<StrengthenGoodsInfo> list = new List<StrengthenGoodsInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Item_StrengthenGoodsInfo_All");
				while (resultDataReader.Read())
				{
					StrengthenGoodsInfo item = new StrengthenGoodsInfo
					{
						ID = (int)resultDataReader["ID"],
						Level = (int)resultDataReader["Level"],
						CurrentEquip = (int)resultDataReader["CurrentEquip"],
						GainEquip = (int)resultDataReader["GainEquip"],
						OrginEquip = (int)resultDataReader["OrginEquip"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllStrengthenGoodsInfo", exception);
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

        public LoadUserBoxInfo[] GetAllTimeBoxAward()
        {
			List<LoadUserBoxInfo> list = new List<LoadUserBoxInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_TimeBox_Award_All");
				while (resultDataReader.Read())
				{
					LoadUserBoxInfo item = new LoadUserBoxInfo
					{
						ID = (int)resultDataReader["ID"],
						Type = (int)resultDataReader["Type"],
						Level = (int)resultDataReader["Level"],
						Condition = (int)resultDataReader["Condition"],
						TemplateID = (int)resultDataReader["TemplateID"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllDaily", exception);
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

        public UserBoxInfo[] GetAllUserBox()
        {
			List<UserBoxInfo> list = new List<UserBoxInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_TimeBox_Award_All");
				while (resultDataReader.Read())
				{
					UserBoxInfo item = new UserBoxInfo
					{
						ID = (int)resultDataReader["ID"],
						Type = (int)resultDataReader["Type"],
						Level = (int)resultDataReader["Level"],
						Condition = (int)resultDataReader["Condition"],
						TemplateID = (int)resultDataReader["TemplateID"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllUserBox", exception);
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

        public EventAwardInfo[] GetEventAwardInfos()
        {
			List<EventAwardInfo> list = new List<EventAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_EventAwardItem_All");
				while (resultDataReader.Read())
				{
					EventAwardInfo item = new EventAwardInfo
					{
						ID = (int)resultDataReader["ID"],
						ActivityType = (int)resultDataReader["ActivityType"],
						TemplateID = (int)resultDataReader["TemplateID"],
						Count = (int)resultDataReader["Count"],
						ValidDate = (int)resultDataReader["ValidDate"],
						IsBinds = (bool)resultDataReader["IsBinds"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						Random = (int)resultDataReader["Random"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllEventAward", exception);
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

        public ItemTemplateInfo[] GetFusionType()
        {
			List<ItemTemplateInfo> list = new List<ItemTemplateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Items_FusionType");
				while (resultDataReader.Read())
				{
					list.Add(InitItemTemplateInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public ItemBoxInfo[] GetItemBoxInfos()
        {
			List<ItemBoxInfo> list = new List<ItemBoxInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_ItemsBox_All");
				while (resultDataReader.Read())
				{
					list.Add(InitItemBoxInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init@Shop_Goods_Box：" + exception);
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

        public ItemTemplateInfo[] GetSingleCategory(int CategoryID)
        {
			List<ItemTemplateInfo> list = new List<ItemTemplateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@CategoryID", SqlDbType.Int, 4)
				};
				sqlParameters[0].Value = CategoryID;
				db.GetReader(ref resultDataReader, "SP_Items_Category_Single", sqlParameters);
				while (resultDataReader.Read())
				{
					list.Add(InitItemTemplateInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public ItemTemplateInfo GetSingleGoods(int goodsID)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ID", SqlDbType.Int, 4)
				};
				sqlParameters[0].Value = goodsID;
				db.GetReader(ref resultDataReader, "SP_Items_Single", sqlParameters);
				if (resultDataReader.Read())
				{
					return InitItemTemplateInfo(resultDataReader);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public ItemBoxInfo[] GetSingleItemsBox(int DataID)
        {
			List<ItemBoxInfo> list = new List<ItemBoxInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ID", SqlDbType.Int, 4)
				};
				sqlParameters[0].Value = DataID;
				db.GetReader(ref resultDataReader, "SP_ItemsBox_Single", sqlParameters);
				while (resultDataReader.Read())
				{
					list.Add(InitItemBoxInfo(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public QuestInfo GetSingleQuest(int questID)
        {
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@QuestID", SqlDbType.Int, 4)
				};
				sqlParameters[0].Value = questID;
				db.GetReader(ref resultDataReader, "SP_Quest_Single", sqlParameters);
				if (resultDataReader.Read())
				{
					return InitQuest(resultDataReader);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
				}
			}
			finally
			{
				if (resultDataReader != null && !resultDataReader.IsClosed)
				{
					resultDataReader.Close();
				}
			}
			return null;
        }

        public AchievementInfo InitAchievement(SqlDataReader reader)
        {
			return new AchievementInfo
			{
				ID = (int)reader["ID"],
				PlaceID = (int)reader["PlaceID"],
				Title = ((reader["Title"] == null) ? "" : reader["Title"].ToString()),
				Detail = ((reader["Detail"] == null) ? "" : reader["Detail"].ToString()),
				NeedMinLevel = (int)reader["NeedMinLevel"],
				NeedMaxLevel = (int)reader["NeedMaxLevel"],
				PreAchievementID = ((reader["PreAchievementID"] == null) ? "" : reader["PreAchievementID"].ToString()),
				IsOther = (int)reader["IsOther"],
				AchievementType = (int)reader["AchievementType"],
				CanHide = (bool)reader["CanHide"],
				StartDate = (DateTime)reader["StartDate"],
				EndDate = (DateTime)reader["EndDate"],
				AchievementPoint = (int)reader["AchievementPoint"],
				IsActive = (int)reader["IsActive"],
				PicID = (int)reader["PicID"],
				IsShare = (bool)reader["IsShare"]
			};
        }

        public AchievementConditionInfo InitAchievementCondition(SqlDataReader reader)
        {
			return new AchievementConditionInfo
			{
				AchievementID = (int)reader["AchievementID"],
				CondictionID = (int)reader["CondictionID"],
				CondictionType = (int)reader["CondictionType"],
				Condiction_Para1 = ((reader["Condiction_Para1"] == null) ? "" : reader["Condiction_Para1"].ToString()),
				Condiction_Para2 = (int)reader["Condiction_Para2"]
			};
        }

        public AchievementRewardInfo InitAchievementReward(SqlDataReader reader)
        {
			return new AchievementRewardInfo
			{
				AchievementID = (int)reader["AchievementID"],
				RewardType = (int)reader["RewardType"],
				RewardPara = ((reader["RewardPara"] == null) ? "" : reader["RewardPara"].ToString()),
				RewardValueId = (int)reader["RewardValueId"],
				RewardCount = (int)reader["RewardCount"]
			};
        }

        public DropCondiction InitDropCondiction(SqlDataReader reader)
        {
			return new DropCondiction
			{
				DropId = (int)reader["DropID"],
				CondictionType = (int)reader["CondictionType"],
				Para1 = (string)reader["Para1"],
				Para2 = (string)reader["Para2"]
			};
        }

        public DropItem InitDropItem(SqlDataReader reader)
        {
			return new DropItem
			{
				Id = (int)reader["Id"],
				DropId = (int)reader["DropId"],
				ItemId = (int)reader["ItemId"],
				ValueDate = (int)reader["ValueDate"],
				IsBind = (bool)reader["IsBind"],
				Random = (int)reader["Random"],
				BeginData = (int)reader["BeginData"],
				EndData = (int)reader["EndData"],
				IsLogs = (bool)reader["IsLogs"],
				IsTips = (bool)reader["IsTips"]
			};
        }

        public EdictumInfo InitEdictum(SqlDataReader reader)
        {
			return new EdictumInfo
			{
				ID = (int)reader["ID"],
				Title = ((reader["Title"] == null) ? "" : reader["Title"].ToString()),
				BeginDate = (DateTime)reader["BeginDate"],
				BeginTime = (DateTime)reader["BeginTime"],
				EndDate = (DateTime)reader["EndDate"],
				EndTime = (DateTime)reader["EndTime"],
				Text = ((reader["Text"] == null) ? "" : reader["Text"].ToString()),
				IsExist = (bool)reader["IsExist"]
			};
        }

        public ItemBoxInfo InitItemBoxInfo(SqlDataReader reader)
        {
			return new ItemBoxInfo
			{
				ID = (int)reader["ID"],
				TemplateId = (int)reader["TemplateId"],
				IsSelect = (bool)reader["IsSelect"],
				IsBind = (bool)reader["IsBind"],
				ItemValid = (int)reader["ItemValid"],
				ItemCount = (int)reader["ItemCount"],
				StrengthenLevel = (int)reader["StrengthenLevel"],
				AttackCompose = (int)reader["AttackCompose"],
				DefendCompose = (int)reader["DefendCompose"],
				AgilityCompose = (int)reader["AgilityCompose"],
				LuckCompose = (int)reader["LuckCompose"],
				Random = (int)reader["Random"],
				IsTips = (int)reader["IsTips"],
				IsLogs = (bool)reader["IsLogs"]
			};
        }

        public ItemRecordTypeInfo InitItemRecordType(SqlDataReader reader)
        {
			return new ItemRecordTypeInfo
			{
				RecordID = (int)reader["RecordID"],
				Name = ((reader["Name"] == null) ? "" : reader["Name"].ToString()),
				Description = ((reader["Description"] == null) ? "" : reader["Description"].ToString())
			};
        }

        public ItemTemplateInfo InitItemTemplateInfo(SqlDataReader reader)
        {
			return new ItemTemplateInfo
			{
				AddTime = reader["AddTime"].ToString(),
				Agility = (int)reader["Agility"],
				Attack = (int)reader["Attack"],
				CanDelete = (bool)reader["CanDelete"],
				CanDrop = (bool)reader["CanDrop"],
				CanEquip = (bool)reader["CanEquip"],
				CanUse = (bool)reader["CanUse"],
				CategoryID = (int)reader["CategoryID"],
				Colors = reader["Colors"].ToString(),
				Defence = (int)reader["Defence"],
				Description = reader["Description"].ToString(),
				Level = (int)reader["Level"],
				Luck = (int)reader["Luck"],
				MaxCount = (int)reader["MaxCount"],
				Name = reader["Name"].ToString(),
				NeedSex = (int)reader["NeedSex"],
				Pic = reader["Pic"].ToString(),
				Data = ((reader["Data"] == null) ? "" : reader["Data"].ToString()),
				Property1 = (int)reader["Property1"],
				Property2 = (int)reader["Property2"],
				Property3 = (int)reader["Property3"],
				Property4 = (int)reader["Property4"],
				Property5 = (int)reader["Property5"],
				Property6 = (int)reader["Property6"],
				Property7 = (int)reader["Property7"],
				Property8 = (int)reader["Property8"],
				Quality = (int)reader["Quality"],
				Script = reader["Script"].ToString(),
				TemplateID = (int)reader["TemplateID"],
				CanCompose = (bool)reader["CanCompose"],
				CanStrengthen = (bool)reader["CanStrengthen"],
				NeedLevel = (int)reader["NeedLevel"],
				BindType = (int)reader["BindType"],
				FusionType = (int)reader["FusionType"],
				FusionRate = (int)reader["FusionRate"],
				FusionNeedRate = (int)reader["FusionNeedRate"],
				Hole = ((reader["Hole"] == null) ? "" : reader["Hole"].ToString()),
				RefineryLevel = (int)reader["RefineryLevel"],
				ReclaimValue = (int)reader["ReclaimValue"],
				ReclaimType = (int)reader["ReclaimType"],
				CanRecycle = (int)reader["CanRecycle"],
				SuitId = (int)reader["SuitID"],
				IsDirty = false
			};
        }

        public QQtipsMessagesInfo InitQQtipsMessagesLoad(SqlDataReader reader)
        {
			return new QQtipsMessagesInfo
			{
				ID = (int)reader["ID"],
				title = ((reader["title"] == null) ? "QQTips" : reader["title"].ToString()),
				content = ((reader["content"] == null) ? "Thông báo, gợi ý hệ thống" : reader["content"].ToString()),
				maxLevel = (int)reader["maxLevel"],
				minLevel = (int)reader["minLevel"],
				outInType = (int)reader["outInType"],
				moduleType = (int)reader["moduleType"],
				inItemID = (int)reader["inItemID"],
				url = ((reader["url"] == null) ? "http://gunny.zing.vn" : reader["url"].ToString())
			};
        }

        public QuestInfo InitQuest(SqlDataReader reader)
        {
			return new QuestInfo
			{
				ID = (int)reader["ID"],
				QuestID = (int)reader["QuestID"],
				Title = ((reader["Title"] == null) ? "" : reader["Title"].ToString()),
				Detail = ((reader["Detail"] == null) ? "" : reader["Detail"].ToString()),
				Objective = ((reader["Objective"] == null) ? "" : reader["Objective"].ToString()),
				NeedMinLevel = (int)reader["NeedMinLevel"],
				NeedMaxLevel = (int)reader["NeedMaxLevel"],
				PreQuestID = ((reader["PreQuestID"] == null) ? "" : reader["PreQuestID"].ToString()),
				NextQuestID = ((reader["NextQuestID"] == null) ? "" : reader["NextQuestID"].ToString()),
				IsOther = (int)reader["IsOther"],
				CanRepeat = (bool)reader["CanRepeat"],
				RepeatInterval = (int)reader["RepeatInterval"],
				RepeatMax = (int)reader["RepeatMax"],
				RewardGP = (int)reader["RewardGP"],
				RewardGold = (int)reader["RewardGold"],
				RewardGiftToken = (int)reader["RewardGiftToken"],
				RewardOffer = (int)reader["RewardOffer"],
				RewardRiches = (int)reader["RewardRiches"],
				RewardBuffID = (int)reader["RewardBuffID"],
				RewardBuffDate = (int)reader["RewardBuffDate"],
				RewardMoney = (int)reader["RewardMoney"],
				Rands = (decimal)reader["Rands"],
				RandDouble = (int)reader["RandDouble"],
				TimeMode = (bool)reader["TimeMode"],
				StartDate = (DateTime)reader["StartDate"],
				EndDate = (DateTime)reader["EndDate"],
				MapID = (int)reader["MapID"],
				AutoEquip = (bool)reader["AutoEquip"],
				RewardMedal = (int)reader["RewardMedal"],
				Rank = ((reader["Rank"] == null) ? "" : reader["Rank"].ToString()),
				StarLev = (int)reader["StarLev"],
				NotMustCount = (int)reader["NotMustCount"]
			};
        }

        public QuestConditionInfo InitQuestCondiction(SqlDataReader reader)
        {
			return new QuestConditionInfo
			{
				QuestID = (int)reader["QuestID"],
				CondictionID = (int)reader["CondictionID"],
				CondictionTitle = ((reader["CondictionTitle"] == null) ? "" : reader["CondictionTitle"].ToString()),
				CondictionType = (int)reader["CondictionType"],
				Para1 = (int)reader["Para1"],
				Para2 = (int)reader["Para2"],
				isOpitional = (bool)reader["isOpitional"]
			};
        }

        public QuestAwardInfo InitQuestGoods(SqlDataReader reader)
        {
			return new QuestAwardInfo
			{
				QuestID = (int)reader["QuestID"],
				RewardItemID = (int)reader["RewardItemID"],
				IsSelect = (bool)reader["IsSelect"],
				IsBind = (bool)reader["IsBind"],
				RewardItemValid = (int)reader["RewardItemValid"],
				RewardItemCount = (int)reader["RewardItemCount"],
				StrengthenLevel = (int)reader["StrengthenLevel"],
				AttackCompose = (int)reader["AttackCompose"],
				DefendCompose = (int)reader["DefendCompose"],
				AgilityCompose = (int)reader["AgilityCompose"],
				LuckCompose = (int)reader["LuckCompose"],
				IsCount = (bool)reader["IsCount"]
			};
        }

        public QuestRateInfo InitQuestRate(SqlDataReader reader)
        {
			return new QuestRateInfo
			{
				BindMoneyRate = ((reader["BindMoneyRate"] == null) ? "" : reader["BindMoneyRate"].ToString()),
				ExpRate = ((reader["ExpRate"] == null) ? "" : reader["ExpRate"].ToString()),
				GoldRate = ((reader["GoldRate"] == null) ? "" : reader["GoldRate"].ToString()),
				ExploitRate = ((reader["ExploitRate"] == null) ? "" : reader["ExploitRate"].ToString()),
				CanOneKeyFinishTime = (int)reader["CanOneKeyFinishTime"]
			};
        }

        public ShopGoodsShowListInfo InitShopGoodsShowListInfo(SqlDataReader reader)
        {
			return new ShopGoodsShowListInfo
			{
				Type = (int)reader["Type"],
				ShopId = (int)reader["ShopId"]
			};
        }

        public EventLiveInfo InitEventLiveInfo(SqlDataReader reader)
        {
			return new EventLiveInfo
			{
				EventID = (int)reader["EventID"],
				Description = reader["Description"].ToString(),
				CondictionType = (int)reader["CondictionType"],
				Condiction_Para1 = (int)reader["Condiction_Para1"],
				Condiction_Para2 = (int)reader["Condiction_Para2"],
				StartDate = (DateTime)reader["StartDate"],
				EndDate = (DateTime)reader["EndDate"]
			};
        }

        public EventLiveGoods InitEventLiveGoods(SqlDataReader reader)
        {
			return new EventLiveGoods
			{
				EventID = (int)reader["EventID"],
				TemplateID = (int)reader["TemplateID"],
				ValidDate = (int)reader["ValidDate"],
				Count = (int)reader["Count"],
				StrengthenLevel = (int)reader["StrengthenLevel"],
				AttackCompose = (int)reader["AttackCompose"],
				DefendCompose = (int)reader["DefendCompose"],
				AgilityCompose = (int)reader["AgilityCompose"],
				LuckCompose = (int)reader["LuckCompose"],
				IsBind = (bool)reader["IsBind"]
			};
        }

        public SubActiveInfo[] GetAllSubActive()
        {
			List<SubActiveInfo> list = new List<SubActiveInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_SubActive_All");
				while (resultDataReader.Read())
				{
					SubActiveInfo item = new SubActiveInfo
					{
						ID = (int)resultDataReader["ID"],
						ActiveID = (int)resultDataReader["ActiveID"],
						SubID = (int)resultDataReader["SubID"],
						IsOpen = (bool)resultDataReader["IsOpen"],
						StartDate = (DateTime)resultDataReader["StartDate"],
						StartTime = (DateTime)resultDataReader["StartTime"],
						EndDate = (DateTime)resultDataReader["EndDate"],
						EndTime = (DateTime)resultDataReader["EndTime"],
						IsContinued = (bool)resultDataReader["IsContinued"],
						ActiveInfo = ((resultDataReader["ActiveInfo"] == null) ? "" : resultDataReader["ActiveInfo"].ToString())
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init AllSubActive", exception);
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

        public CommunalActiveAwardInfo[] GetAllCommunalActiveAward()
        {
			List<CommunalActiveAwardInfo> list = new List<CommunalActiveAwardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_CommunalActiveAward_All");
				while (resultDataReader.Read())
				{
					CommunalActiveAwardInfo item = new CommunalActiveAwardInfo
					{
						ID = (int)resultDataReader["ID"],
						ActiveID = (int)resultDataReader["ActiveID"],
						IsArea = (int)resultDataReader["IsArea"],
						RandID = (int)resultDataReader["RandID"],
						TemplateID = (int)resultDataReader["TemplateID"],
						StrengthenLevel = (int)resultDataReader["StrengthenLevel"],
						AttackCompose = (int)resultDataReader["AttackCompose"],
						DefendCompose = (int)resultDataReader["DefendCompose"],
						AgilityCompose = (int)resultDataReader["AgilityCompose"],
						LuckCompose = (int)resultDataReader["LuckCompose"],
						Count = (int)resultDataReader["Count"],
						IsBind = (bool)resultDataReader["IsBind"],
						IsTime = (bool)resultDataReader["IsTime"],
						ValidDate = (int)resultDataReader["ValidDate"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCommunalActiveAward", exception);
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

        public CommunalActiveExpInfo[] GetAllCommunalActiveExp()
        {
			List<CommunalActiveExpInfo> list = new List<CommunalActiveExpInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_CommunalActiveExp_All");
				while (resultDataReader.Read())
				{
					CommunalActiveExpInfo item = new CommunalActiveExpInfo
					{
						ActiveID = (int)resultDataReader["ActiveID"],
						Grade = (int)resultDataReader["Grade"],
						Exp = (int)resultDataReader["Exp"],
						AddExpPlus = (int)resultDataReader["AddExpPlus"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCommunalActiveExp", exception);
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

        public SubActiveConditionInfo[] GetAllSubActiveCondition(int ActiveID)
        {
			List<SubActiveConditionInfo> list = new List<SubActiveConditionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[1]
				{
					new SqlParameter("@ActiveID", ActiveID)
				};
				db.GetReader(ref resultDataReader, "SP_SubActiveCondition_All", sqlParameters);
				while (resultDataReader.Read())
				{
					SubActiveConditionInfo item = new SubActiveConditionInfo
					{
						ID = (int)resultDataReader["ID"],
						ActiveID = (int)resultDataReader["ActiveID"],
						SubID = (int)resultDataReader["SubID"],
						ConditionID = (int)resultDataReader["ConditionID"],
						Type = (int)resultDataReader["Type"],
						Value = ((resultDataReader["Value"] == null) ? "" : resultDataReader["Value"].ToString()),
						AwardType = (int)resultDataReader["AwardType"],
						AwardValue = ((resultDataReader["AwardValue"] == null) ? "" : resultDataReader["AwardValue"].ToString()),
						IsValid = (bool)resultDataReader["IsValid"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init AllSubActive", exception);
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

        public CommunalActiveInfo[] GetAllCommunalActive()
        {
			List<CommunalActiveInfo> list = new List<CommunalActiveInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_CommunalActive_All");
				while (resultDataReader.Read())
				{
					CommunalActiveInfo item = new CommunalActiveInfo
					{
						ActiveID = (int)resultDataReader["ActiveID"],
						BeginTime = (DateTime)resultDataReader["BeginTime"],
						EndTime = (DateTime)resultDataReader["EndTime"],
						LimitGrade = (int)resultDataReader["LimitGrade"],
						DayMaxScore = (int)resultDataReader["DayMaxScore"],
						MinScore = (int)resultDataReader["MinScore"],
						AddPropertyByMoney = (string)resultDataReader["AddPropertyByMoney"],
						AddPropertyByProp = (string)resultDataReader["AddPropertyByProp"],
						IsReset = (bool)resultDataReader["IsReset"],
						IsSendAward = (bool)resultDataReader["IsSendAward"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCommunalActive", exception);
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

        public FairBattleRewardInfo[] GetAllFairBattleReward()
        {
			List<FairBattleRewardInfo> list = new List<FairBattleRewardInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_FairBattleReward_All");
				while (resultDataReader.Read())
				{
					FairBattleRewardInfo item = new FairBattleRewardInfo
					{
						Prestige = (int)resultDataReader["Prestige"],
						Level = (int)resultDataReader["Level"],
						Name = (string)resultDataReader["Name"],
						PrestigeForWin = (int)resultDataReader["PrestigeForWin"],
						PrestigeForLose = (int)resultDataReader["PrestigeForLose"],
						Title = (string)resultDataReader["Title"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllFairBattleReward", exception);
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

        public CardUpdateConditionInfo[] GetAllCardUpdateCondition()
        {
			List<CardUpdateConditionInfo> list = new List<CardUpdateConditionInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_CardUpdateCondiction");
				while (resultDataReader.Read())
				{
					CardUpdateConditionInfo item = new CardUpdateConditionInfo
					{
						Level = (int)resultDataReader["Level"],
						Exp = (int)resultDataReader["Exp"],
						MinExp = (int)resultDataReader["MinExp"],
						MaxExp = (int)resultDataReader["MaxExp"],
						UpdateCardCount = (int)resultDataReader["UpdateCardCount"],
						ResetCardCount = (int)resultDataReader["ResetCardCount"],
						ResetMoney = (int)resultDataReader["ResetMoney"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public CardGrooveUpdateInfo[] GetAllCardGrooveUpdate()
        {
			List<CardGrooveUpdateInfo> list = new List<CardGrooveUpdateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_CardGrooveUpdate_All");
				while (resultDataReader.Read())
				{
					list.Add(InitCardGrooveUpdate(resultDataReader));
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllCardGrooveUpdate", exception);
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

        public CardUpdateInfo[] GetAllCardUpdateInfo()
        {
			List<CardUpdateInfo> list = new List<CardUpdateInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Get_CardUpdateInfo");
				while (resultDataReader.Read())
				{
					CardUpdateInfo item = new CardUpdateInfo
					{
						Id = (int)resultDataReader["Id"],
						Level = (int)resultDataReader["Level"],
						Attack = (int)resultDataReader["Attack"],
						Defend = (int)resultDataReader["Defend"],
						Agility = (int)resultDataReader["Agility"],
						Lucky = (int)resultDataReader["Lucky"],
						Guard = (int)resultDataReader["Guard"],
						Damage = (int)resultDataReader["Damage"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
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

        public CardGrooveUpdateInfo InitCardGrooveUpdate(SqlDataReader reader)
        {
			return new CardGrooveUpdateInfo
			{
				ID = (int)reader["ID"],
				Attack = (int)reader["Attack"],
				Defend = (int)reader["Defend"],
				Agility = (int)reader["Agility"],
				Lucky = (int)reader["Lucky"],
				Damage = (int)reader["Damage"],
				Guard = (int)reader["Guard"],
				Level = (int)reader["Level"],
				Type = (int)reader["Type"],
				Exp = (int)reader["Exp"]
			};
        }

        public LevelInfo[] GetAllLevel()
        {
			List<LevelInfo> list = new List<LevelInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Level_All");
				while (resultDataReader.Read())
				{
					LevelInfo item = new LevelInfo
					{
						Grade = (int)resultDataReader["Grade"],
						GP = (int)resultDataReader["GP"],
						Blood = (int)resultDataReader["Blood"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllLevel", exception);
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

        public ExerciseInfo[] GetAllExercise()
        {
			List<ExerciseInfo> list = new List<ExerciseInfo>();
			SqlDataReader resultDataReader = null;
			try
			{
				db.GetReader(ref resultDataReader, "SP_Exercise_All");
				while (resultDataReader.Read())
				{
					ExerciseInfo item = new ExerciseInfo
					{
						Grage = (int)resultDataReader["Grage"],
						GP = (int)resultDataReader["GP"],
						ExerciseA = (int)resultDataReader["ExerciseA"],
						ExerciseAG = (int)resultDataReader["ExerciseAG"],
						ExerciseD = (int)resultDataReader["ExerciseD"],
						ExerciseH = (int)resultDataReader["ExerciseH"],
						ExerciseL = (int)resultDataReader["ExerciseL"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllExercise", exception);
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

        public PetConfig[] GetAllPetConfig()
        {
			List<PetConfig> petConfigList = new List<PetConfig>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetConfig_All");
				while (ResultDataReader.Read())
				{
					petConfigList.Add(new PetConfig
					{
						Name = ResultDataReader["Name"].ToString(),
						Value = ResultDataReader["Value"].ToString()
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetConfig", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return petConfigList.ToArray();
        }

        public PetLevel[] GetAllPetLevel()
        {
			List<PetLevel> petLevelList = new List<PetLevel>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetLevel_All");
				while (ResultDataReader.Read())
				{
					petLevelList.Add(new PetLevel
					{
						Level = (int)ResultDataReader["Level"],
						GP = (int)ResultDataReader["GP"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetLevel", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return petLevelList.ToArray();
        }

        public PetTemplateInfo[] GetAllPetTemplateInfo()
        {
			List<PetTemplateInfo> petTemplateInfoList = new List<PetTemplateInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetTemplateInfo_All");
				while (ResultDataReader.Read())
				{
					petTemplateInfoList.Add(new PetTemplateInfo
					{
						TemplateID = (int)ResultDataReader["TemplateID"],
						Name = (string)ResultDataReader["Name"],
						KindID = (int)ResultDataReader["KindID"],
						Description = (string)ResultDataReader["Description"],
						Pic = (string)ResultDataReader["Pic"],
						RareLevel = (int)ResultDataReader["RareLevel"],
						MP = (int)ResultDataReader["MP"],
						StarLevel = (int)ResultDataReader["StarLevel"],
						GameAssetUrl = (string)ResultDataReader["GameAssetUrl"],
						HighAgility = (int)ResultDataReader["HighAgility"],
						HighAgilityGrow = (int)ResultDataReader["HighAgilityGrow"],
						HighAttack = (int)ResultDataReader["HighAttack"],
						HighAttackGrow = (int)ResultDataReader["HighAttackGrow"],
						HighBlood = (int)ResultDataReader["HighBlood"],
						HighBloodGrow = (int)ResultDataReader["HighBloodGrow"],
						HighDamage = (int)ResultDataReader["HighDamage"],
						HighDamageGrow = (int)ResultDataReader["HighDamageGrow"],
						HighDefence = (int)ResultDataReader["HighDefence"],
						HighDefenceGrow = (int)ResultDataReader["HighDefenceGrow"],
						HighGuard = (int)ResultDataReader["HighGuard"],
						HighGuardGrow = (int)ResultDataReader["HighGuardGrow"],
						HighLuck = (int)ResultDataReader["HighLuck"],
						HighLuckGrow = (int)ResultDataReader["HighLuckGrow"],
						WashGetCount = (int)ResultDataReader["WashGetCount"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetTemplateInfo", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return petTemplateInfoList.ToArray();
        }

        public PetSkillTemplateInfo[] GetAllPetSkillTemplateInfo()
        {
			List<PetSkillTemplateInfo> skillTemplateInfoList = new List<PetSkillTemplateInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetSkillTemplateInfo_All");
				while (ResultDataReader.Read())
				{
					skillTemplateInfoList.Add(new PetSkillTemplateInfo
					{
						PetTemplateID = (int)ResultDataReader["PetTemplateID"],
						KindID = (int)ResultDataReader["KindID"],
						GetTypes = (int)ResultDataReader["GetType"],
						SkillID = (int)ResultDataReader["SkillID"],
						SkillBookID = (int)ResultDataReader["SkillBookID"],
						MinLevel = (int)ResultDataReader["MinLevel"],
						DeleteSkillIDs = ResultDataReader["DeleteSkillIDs"].ToString()
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetSkillTemplateInfo", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return skillTemplateInfoList.ToArray();
        }

        public PetSkillInfo[] GetAllPetSkillInfo()
        {
			List<PetSkillInfo> petSkillInfoList = new List<PetSkillInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetSkillInfo_All");
				while (ResultDataReader.Read())
				{
					petSkillInfoList.Add(new PetSkillInfo
					{
						ID = (int)ResultDataReader["ID"],
						Name = ResultDataReader["Name"].ToString(),
						ElementIDs = ResultDataReader["ElementIDs"].ToString(),
						Description = ResultDataReader["Description"].ToString(),
						BallType = (int)ResultDataReader["BallType"],
						NewBallID = (int)ResultDataReader["NewBallID"],
						CostMP = (int)ResultDataReader["CostMP"],
						Pic = (int)ResultDataReader["Pic"],
						Action = ResultDataReader["Action"].ToString(),
						EffectPic = ResultDataReader["EffectPic"].ToString(),
						Delay = (int)ResultDataReader["Delay"],
						ColdDown = (int)ResultDataReader["ColdDown"],
						GameType = (int)ResultDataReader["GameType"],
						Probability = (int)ResultDataReader["Probability"],
						Damage = (int)ResultDataReader["Damage"],
						DamageCrit = (int)ResultDataReader["DamageCrit"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetSkillInfo", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return petSkillInfoList.ToArray();
        }

        public PetSkillElementInfo[] GetAllPetSkillElementInfo()
        {
			List<PetSkillElementInfo> skillElementInfoList = new List<PetSkillElementInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetSkillElementInfo_All");
				while (ResultDataReader.Read())
				{
					skillElementInfoList.Add(new PetSkillElementInfo
					{
						ID = (int)ResultDataReader["ID"],
						Name = ResultDataReader["Name"].ToString(),
						EffectPic = ResultDataReader["EffectPic"].ToString(),
						Description = ResultDataReader["Description"].ToString(),
						Pic = (int)ResultDataReader["Pic"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetSkillElementInfo", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return skillElementInfoList.ToArray();
        }

        public PetExpItemPriceInfo[] GetAllPetExpItemPrice()
        {
			List<PetExpItemPriceInfo> infos = new List<PetExpItemPriceInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_PetExpItemPriceInfo_All");
				while (reader.Read())
				{
					PetExpItemPriceInfo info = new PetExpItemPriceInfo();
					info.ID = (int)reader["ID"];
					info.Count = (int)reader["Count"];
					info.Money = (int)reader["Money"];
					info.ItemCount = (int)reader["ItemCount"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetTemplateInfo", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public PetFightPropertyInfo[] GetAllPetFightProperty()
        {
			List<PetFightPropertyInfo> fightPropertyInfoList = new List<PetFightPropertyInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetFightProperty_All");
				while (ResultDataReader.Read())
				{
					fightPropertyInfoList.Add(new PetFightPropertyInfo
					{
						ID = (int)ResultDataReader["ID"],
						Exp = (int)ResultDataReader["Exp"],
						Attack = (int)ResultDataReader["Attack"],
						Agility = (int)ResultDataReader["Agility"],
						Defence = (int)ResultDataReader["Defence"],
						Lucky = (int)ResultDataReader["Lucky"],
						Blood = (int)ResultDataReader["Blood"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetFightProperty", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return fightPropertyInfoList.ToArray();
        }

        public PetStarExpInfo[] GetAllPetStarExp()
        {
			List<PetStarExpInfo> petStarExpInfoList = new List<PetStarExpInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_PetStarExp_All");
				while (ResultDataReader.Read())
				{
					petStarExpInfoList.Add(new PetStarExpInfo
					{
						Exp = (int)ResultDataReader["Exp"],
						OldID = (int)ResultDataReader["OldID"],
						NewID = (int)ResultDataReader["NewID"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllPetStarExp", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return petStarExpInfoList.ToArray();
        }

        public ConsortiaBuffTempInfo[] GetAllConsortiaBuffTemp()
        {
			List<ConsortiaBuffTempInfo> consortiaBuffTempInfoList = new List<ConsortiaBuffTempInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_Consortia_Buff_Temp_All");
				while (ResultDataReader.Read())
				{
					consortiaBuffTempInfoList.Add(new ConsortiaBuffTempInfo
					{
						id = (int)ResultDataReader["id"],
						name = (string)ResultDataReader["name"],
						descript = (string)ResultDataReader["descript"],
						type = (int)ResultDataReader["type"],
						level = (int)ResultDataReader["level"],
						value = (int)ResultDataReader["value"],
						riches = (int)ResultDataReader["riches"],
						metal = (int)ResultDataReader["metal"],
						pic = (int)ResultDataReader["pic"],
						group = (int)ResultDataReader["group"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllConsortiaBuffTemp", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return consortiaBuffTempInfoList.ToArray();
        }

        public ConsortiaLevelInfo[] GetAllConsortiaLevel()
        {
			List<ConsortiaLevelInfo> consortiaLevelInfoList = new List<ConsortiaLevelInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_Consortia_Level_All");
				while (ResultDataReader.Read())
				{
					consortiaLevelInfoList.Add(new ConsortiaLevelInfo
					{
						Count = (int)ResultDataReader["Count"],
						Deduct = (int)ResultDataReader["Deduct"],
						Level = (int)ResultDataReader["Level"],
						NeedGold = (int)ResultDataReader["NeedGold"],
						NeedItem = (int)ResultDataReader["NeedItem"],
						Reward = (int)ResultDataReader["Reward"],
						Riches = (int)ResultDataReader["Riches"],
						ShopRiches = (int)ResultDataReader["ShopRiches"],
						SmithRiches = (int)ResultDataReader["SmithRiches"],
						StoreRiches = (int)ResultDataReader["StoreRiches"],
						BufferRiches = (int)ResultDataReader["BufferRiches"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllConsortiaLevel", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return consortiaLevelInfoList.ToArray();
        }

        public ConsortiaBadgeConfigInfo[] GetAllConsortiaBadgeConfig()
        {
			List<ConsortiaBadgeConfigInfo> consortiaBadgeConfigInfoList = new List<ConsortiaBadgeConfigInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_Consortia_Badge_Config_All");
				while (ResultDataReader.Read())
				{
					consortiaBadgeConfigInfoList.Add(InitConsortiaBadgeConfig(ResultDataReader));
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllConsortiaBadgeConfig", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return consortiaBadgeConfigInfoList.ToArray();
        }

        public ConsortiaBadgeConfigInfo InitConsortiaBadgeConfig(SqlDataReader reader)
        {
			return new ConsortiaBadgeConfigInfo
			{
				BadgeID = (int)reader["BadgeID"],
				BadgeName = ((reader["BadgeName"] == null) ? "" : reader["BadgeName"].ToString()),
				Cost = (int)reader["Cost"],
				LimitLevel = (int)reader["LimitLevel"],
				ValidDate = (int)reader["ValidDate"]
			};
        }

        public GoldEquipTemplateInfo[] GetAllGoldEquipTemplateLoad()
        {
			List<GoldEquipTemplateInfo> equipTemplateInfoList = new List<GoldEquipTemplateInfo>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_GoldEquipTemplateLoad_All");
				while (ResultDataReader.Read())
				{
					equipTemplateInfoList.Add(InitGoldEquipTemplateLoad(ResultDataReader));
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllGoldEquipTemplateLoad", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return equipTemplateInfoList.ToArray();
        }

        public GoldEquipTemplateInfo InitGoldEquipTemplateLoad(SqlDataReader reader)
        {
			return new GoldEquipTemplateInfo
			{
				ID = (int)reader["ID"],
				OldTemplateId = (int)reader["OldTemplateId"],
				NewTemplateId = (int)reader["NewTemplateId"],
				CategoryID = (int)reader["CategoryID"],
				Strengthen = (int)reader["Strengthen"],
				Attack = (int)reader["Attack"],
				Defence = (int)reader["Defence"],
				Agility = (int)reader["Agility"],
				Luck = (int)reader["Luck"],
				Damage = (int)reader["Damage"],
				Guard = (int)reader["Guard"],
				Boold = (int)reader["Boold"],
				BlessID = (int)reader["BlessID"],
				Pic = ((reader["pic"] == DBNull.Value) ? "" : reader["pic"].ToString())
			};
        }

        public PetMoePropertyInfo[] GetAllPetMoeProperty()
        {
			List<PetMoePropertyInfo> infos = new List<PetMoePropertyInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Pet_Moe_Property_All");
				while (reader.Read())
				{
					infos.Add(InitPetMoePropertyInfo(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("InitPetMoePropertyInfo", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public PetMoePropertyInfo InitPetMoePropertyInfo(SqlDataReader dr)
        {
			PetMoePropertyInfo info = new PetMoePropertyInfo();
			info.Level = (int)dr["Level"];
			info.Attack = (int)dr["Attack"];
			info.Lucky = (int)dr["Lucky"];
			info.Agility = (int)dr["Agility"];
			info.Blood = (int)dr["Blood"];
			info.Defence = (int)dr["Defence"];
			info.Guard = (int)dr["Guard"];
			info.Exp = (int)dr["Exp"];
			return info;
        }

        public void Update_Suit_Kill(Suit_Manager A)
        {
			try
			{
				SqlParameter[] para = new SqlParameter[2]
				{
					new SqlParameter("@kill", A.Kill_List),
					new SqlParameter("@UserID", A.UserID)
				};
				db.RunProcedure("SP_Suit_Manager_Update", para);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_Suit_Manager_Update error!", e);
				}
			}
        }

        public void Reset_Suit_Kill(int UserID)
        {
			try
			{
				SqlParameter[] para = new SqlParameter[1]
				{
					new SqlParameter("@UserID", UserID)
				};
				db.RunProcedure("SP_Suit_Manager_Reset", para);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_Suit_Manager_Reset error!", e);
				}
			}
        }

        public Suit_TemplateID[] Load_Suit_TemplateID()
        {
			List<Suit_TemplateID> infos = new List<Suit_TemplateID>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Suit_TemplateID");
				while (reader.Read())
				{
					infos.Add(new Suit_TemplateID
					{
						ID = (int)reader["ID"],
						ContainEquip = (string)reader["ContainEquip"],
						PartName = (string)reader["PartName"]
					});
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_Suit_TemplateID", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public Suit_TemplateInfo[] Load_Suit_TemplateInfo()
        {
			List<Suit_TemplateInfo> infos = new List<Suit_TemplateInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Suit_TemplateInfo");
				while (reader.Read())
				{
					infos.Add(new Suit_TemplateInfo
					{
						SuitId = (int)reader["SuitId"],
						SuitName = (string)reader["SuitName"],
						EqipCount1 = (int)reader["EqipCount1"],
						SkillDescribe1 = (string)reader["SkillDescribe1"],
						Skill1 = (string)reader["Skill1"],
						EqipCount2 = (int)reader["EqipCount2"],
						SkillDescribe2 = (string)reader["SkillDescribe2"],
						Skill2 = (string)reader["Skill2"],
						EqipCount3 = (int)reader["EqipCount3"],
						SkillDescribe3 = (string)reader["SkillDescribe3"],
						Skill3 = (string)reader["Skill3"],
						EqipCount4 = (int)reader["EqipCount4"],
						SkillDescribe4 = (string)reader["SkillDescribe4"],
						Skill4 = (string)reader["Skill4"],
						EqipCount5 = (int)reader["EqipCount5"],
						SkillDescribe5 = (string)reader["SkillDescribe5"],
						Skill5 = (string)reader["Skill5"]
					});
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_Suit_TemplateInfo", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public AccumulAtiveLoginAwardInfo[] GetAccumulAtiveLoginAwardInfos()
        {
			List<AccumulAtiveLoginAwardInfo> infos = new List<AccumulAtiveLoginAwardInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_AccumulAtiveLoginAward_All");
				while (reader.Read())
				{
					AccumulAtiveLoginAwardInfo info = new AccumulAtiveLoginAwardInfo();
					info.ID = (int)reader["ID"];
					info.RewardItemID = (int)reader["RewardItemID"];
					info.Type = (int)reader["Type"];
					info.IsSelect = (bool)reader["IsSelect"];
					info.IsBind = (bool)reader["IsBind"];
					info.RewardItemValid = (int)reader["RewardItemValid"];
					info.RewardItemCount = (int)reader["RewardItemCount"];
					info.StrengthenLevel = (int)reader["StrengthenLevel"];
					info.AttackCompose = (int)reader["AttackCompose"];
					info.DefendCompose = (int)reader["DefendCompose"];
					info.AgilityCompose = (int)reader["AgilityCompose"];
					info.LuckCompose = (int)reader["LuckCompose"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Accumul_Ative_Login_Award：" + e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public NewTitleInfo[] GetAllNewTitle()
        {
			List<NewTitleInfo> infos = new List<NewTitleInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_New_Title_All");
				while (reader.Read())
				{
					infos.Add(InitNewTitleInfo(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("InitNewTitleInfo", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
        }

        public NewTitleInfo InitNewTitleInfo(SqlDataReader dr)
        {
			NewTitleInfo info = new NewTitleInfo();
			info.ID = (int)dr["ID"];
			info.Order = (int)dr["Order"];
			info.Show = (int)dr["Show"];
			info.Name = (string)dr["Name"];
			info.Pic = (int)dr["Pic"];
			info.Att = (int)dr["Att"];
			info.Def = (int)dr["Def"];
			info.Agi = (int)dr["Agi"];
			info.Luck = (int)dr["Luck"];
			info.Desc = (string)dr["Desc"];
			return info;
        }

		public ConsortiaTaskConditions[] GetAllConsortiaTask()
		{
			List<ConsortiaTaskConditions> consortiaTaskInfoList = new List<ConsortiaTaskConditions>();
			SqlDataReader ResultDataReader = null;
			try
			{
				db.GetReader(ref ResultDataReader, "SP_Consortia_Task_All");
				while (ResultDataReader.Read())
				{
					consortiaTaskInfoList.Add(new ConsortiaTaskConditions
					{
						ID = (int)ResultDataReader["ID"],
						Content = (string)ResultDataReader["Content"],
						Type = (int)ResultDataReader["Type"],
						Target = (int)ResultDataReader["Target"],
						TargetCount = (int)ResultDataReader["TargetCount"],
						Para1 = (int)ResultDataReader["Para1"],
						Para2 = (int)ResultDataReader["Para2"],
						Level = (int)ResultDataReader["Level"]
					});
				}
			}
			catch (Exception ex)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllConsortiaTask", ex);
				}
			}
			finally
			{
				if (ResultDataReader != null && !ResultDataReader.IsClosed)
				{
					ResultDataReader.Close();
				}
			}
			return consortiaTaskInfoList.ToArray();
		}

		public CategoryInfo[] GetSingleCategoryName(int ID)
		{
			List<CategoryInfo> infos = new List<CategoryInfo>();
			SqlDataReader reader = null;
			try
			{
				SqlParameter[] para = new SqlParameter[1]
				{
					new SqlParameter("@ID", SqlDbType.Int)
				};
				para[0].Value = ID;
				db.GetReader(ref reader, "SP_Category_Name_Single", para);
				while (reader.Read())
				{
					CategoryInfo item = new CategoryInfo
					{
						ID = (int)reader["ID"],
						Name = ((reader["Name"] == null) ? "" : reader["Name"].ToString()),
						Place = (int)reader["Place"],
						Remark = ((reader["Remark"] == null) ? "" : reader["Remark"].ToString())
					};
					infos.Add(item);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
		}

		public ActivitySystemItemInfo[] GetAllActivitySystemItem()
		{
			List<ActivitySystemItemInfo> infos = new List<ActivitySystemItemInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_ActivitySystemItem_All");
				while (reader.Read())
				{
					ActivitySystemItemInfo info = new ActivitySystemItemInfo();
					info.ID = (int)reader["ID"];
					info.ActivityType = (int)reader["ActivityType"];
					info.Quality = (int)reader["Quality"];
					info.TemplateID = (int)reader["TemplateID"];
					info.Count = (int)reader["Count"];
					info.ValidDate = (int)reader["ValidDate"];
					info.IsBind = (bool)reader["IsBind"];
					info.StrengthLevel = (int)reader["StrengthLevel"];
					info.AttackCompose = (int)reader["AttackCompose"];
					info.DefendCompose = (int)reader["DefendCompose"];
					info.AgilityCompose = (int)reader["AgilityCompose"];
					info.LuckCompose = (int)reader["LuckCompose"];
					info.Probability = (int)reader["Probability"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("GetAllActivitySystemItem", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}

		public FightSpiritTemplateInfo[] GetAllFightSpiritTemplate()
		{
			List<FightSpiritTemplateInfo> infos = new List<FightSpiritTemplateInfo>();
			SqlDataReader reader = null;
			try
			{
				this.db.GetReader(ref reader, "SP_FightSpiritTemplate_All");
				while (reader.Read())
				{
					infos.Add(new FightSpiritTemplateInfo
					{
						ID = (int)reader["ID"],
						FightSpiritID = (int)reader["FightSpiritID"],
						FightSpiritIcon = (string)reader["FightSpiritIcon"],
						Level = (int)reader["Level"],
						Exp = (int)reader["Exp"],
						Attack = (int)reader["Attack"],
						Defence = (int)reader["Defence"],
						Agility = (int)reader["Agility"],
						Lucky = (int)reader["Lucky"],
						Blood = (int)reader["Blood"]
					});
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetFightSpiritTemplateAll", e);
				}
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return infos.ToArray();
		}

		public ClothGroupTemplateInfo[] GetAllClothGroup()
		{
			List<ClothGroupTemplateInfo> list = new List<ClothGroupTemplateInfo>();
			SqlDataReader sqlDataReader = null;
			try
			{
				this.db.GetReader(ref sqlDataReader, "SP_ClothGroup_All");
				while (sqlDataReader.Read())
				{
					ClothGroupTemplateInfo item = new ClothGroupTemplateInfo
					{
						ItemID = (int)sqlDataReader["ItemID"],
						ID = (int)sqlDataReader["ID"],
						TemplateID = (int)sqlDataReader["TemplateID"],
						Sex = (int)sqlDataReader["Sex"],
						Description = (int)sqlDataReader["Description"],
						Cost = (int)sqlDataReader["Cost"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_ClothGroup_All", exception);
				}
			}
			finally
			{
				if (sqlDataReader != null && !sqlDataReader.IsClosed)
				{
					sqlDataReader.Close();
				}
			}
			return list.ToArray();
		}

		public ClothPropertyTemplateInfo[] GetAllClothProperty()
		{
			List<ClothPropertyTemplateInfo> list = new List<ClothPropertyTemplateInfo>();
			SqlDataReader sqlDataReader = null;
			try
			{
				this.db.GetReader(ref sqlDataReader, "SP_ClothProperty_All");
				while (sqlDataReader.Read())
				{
					ClothPropertyTemplateInfo item = new ClothPropertyTemplateInfo
					{
						ID = (int)sqlDataReader["ID"],
						Sex = (int)sqlDataReader["Sex"],
						Name = (string)sqlDataReader["Name"],
						Attack = (int)sqlDataReader["Attack"],
						Defend = (int)sqlDataReader["Defend"],
						Luck = (int)sqlDataReader["Luck"],
						Agility = (int)sqlDataReader["Agility"],
						Blood = (int)sqlDataReader["Blood"],
						Damage = (int)sqlDataReader["Damage"],
						Guard = (int)sqlDataReader["Guard"],
						Cost = (int)sqlDataReader["Cost"]
					};
					list.Add(item);
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("GetAllClothProperty", exception);
				}
			}
			finally
			{
				if (sqlDataReader != null && !sqlDataReader.IsClosed)
				{
					sqlDataReader.Close();
				}
			}
			return list.ToArray();
		}

		public TotemInfo[] GetAllTotem()
		{
			List<TotemInfo> infos = new List<TotemInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Totem_All");
				while (reader.Read())
				{
					TotemInfo info = new TotemInfo();
					info.ID = (int)reader["ID"];
					info.ConsumeExp = (int)reader["ConsumeExp"];
					info.ConsumeHonor = (int)reader["ConsumeHonor"];
					info.AddAttack = (int)reader["AddAttack"];
					info.AddDefence = (int)reader["AddDefence"];
					info.AddAgility = (int)reader["AddAgility"];
					info.AddLuck = (int)reader["AddLuck"];
					info.AddBlood = (int)reader["AddBlood"];
					info.AddDamage = (int)reader["AddDamage"];
					info.AddGuard = (int)reader["AddGuard"];
					info.Random = (int)reader["Random"];
					info.Page = (int)reader["Page"];
					info.Layers = (int)reader["Layers"];
					info.Location = (int)reader["Location"];
					info.Point = (int)reader["Point"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("GetTotemAll", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}

		public TotemHonorTemplateInfo[] GetAllTotemHonorTemplate()
		{
			List<TotemHonorTemplateInfo> infos = new List<TotemHonorTemplateInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_TotemHonorTemplate_All");
				while (reader.Read())
				{
					TotemHonorTemplateInfo info = new TotemHonorTemplateInfo();
					info.ID = (int)reader["ID"];
					info.NeedMoney = (int)reader["NeedMoney"];
					info.Type = (int)reader["Type"];
					info.AddHonor = (int)reader["AddHonor"];
					infos.Add(info);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("GetTotemHonorTemplateInfo", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}

		public DailyLeagueAwardInfo[] GetAllDailyLeagueAward()
		{
			List<DailyLeagueAwardInfo> infos = new List<DailyLeagueAwardInfo>();
			SqlDataReader reader = null;
			try
			{
				db.GetReader(ref reader, "SP_Daily_League_Award_All");
				while (reader.Read())
				{
					infos.Add(InitDailyLeagueAwardInfo(reader));
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("InitDailyLeagueAwardInfo", e);
			}
			finally
			{
				if (reader != null && !reader.IsClosed)
					reader.Close();
			}
			return infos.ToArray();
		}


		public DailyLeagueAwardInfo InitDailyLeagueAwardInfo(SqlDataReader dr)
		{
			DailyLeagueAwardInfo info = new DailyLeagueAwardInfo();
			info.Level = (int)dr["Level"];
			info.Class = (int)dr["Class"];
			info.Count = (int)dr["Count"];
			info.TemplateID = (int)dr["TemplateID"];
			info.RewardID = (int)dr["RewardID"];
			info.StrengthenLevel = (int)dr["StrengthenLevel"];
			info.ItemValid = (int)dr["ItemValid"];
			info.IsBind = (bool)dr["IsBind"];
			info.AgilityCompose = (int)dr["AgilityCompose"];
			info.AttackCompose = (int)dr["AttackCompose"];
			info.DefendCompose = (int)dr["DefendCompose"];
			info.LuckCompose = (int)dr["LuckCompose"];
			info.Hole1 = (int)dr["Hole1"];
			info.Hole2 = (int)dr["Hole2"];
			info.Hole3 = (int)dr["Hole3"];
			info.Hole4 = (int)dr["Hole4"];
			info.Hole5 = (int)dr["Hole5"];
			info.Hole5Exp = (int)dr["Hole5Exp"];
			info.Hole5Level = (int)dr["Hole5Level"];
			info.Hole6 = (int)dr["Hole6"];
			info.Hole6Exp = (int)dr["Hole6Exp"];
			info.Hole6Level = (int)dr["Hole6Level"];
			return info;
		}
	}
}
