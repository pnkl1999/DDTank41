using System;
using System.Xml.Linq;
using SqlDataProvider.Data;

namespace Road.Flash
{
    public class FlashUtils
    {
        public static XElement CreateSuit_TemplateID(Suit_TemplateID info)
        {
            return new XElement("Item",
                    new XAttribute("ID", info.ID),
                    new XAttribute("ContainEquip", info.ContainEquip),
                    new XAttribute("PartName", info.PartName)
                );
        }
        public static XElement CreateSuit_TemplateInfo(Suit_TemplateInfo info)
        {
            return new XElement("Item",
                    new XAttribute("SuitId", info.SuitId),
                    new XAttribute("SuitName", info.SuitName),
                    new XAttribute("EqipCount1", info.EqipCount1),
                    new XAttribute("SkillDescribe1", info.SkillDescribe1),
                    new XAttribute("Skill1", info.Skill1),
                    new XAttribute("EqipCount2", info.EqipCount2),
                    new XAttribute("SkillDescribe2", info.SkillDescribe2),
                    new XAttribute("Skill2", info.Skill2),
                    new XAttribute("EqipCount3", info.EqipCount3),
                    new XAttribute("SkillDescribe3", info.SkillDescribe3),
                    new XAttribute("Skill3", info.Skill3),
                    new XAttribute("EqipCount4", info.EqipCount4),
                    new XAttribute("SkillDescribe4", info.SkillDescribe4),
                    new XAttribute("Skill4", info.Skill4),
                    new XAttribute("EqipCount5", info.EqipCount5),
                    new XAttribute("SkillDescribe5", info.SkillDescribe5),
                    new XAttribute("Skill5", info.Skill5)
                );
        }
        public static XElement CreateNewTitleInfo(NewTitleInfo info)
        {
            return new XElement("Item",
                    new XAttribute("ID", info.ID),
                    new XAttribute("Order", info.Order),
                    new XAttribute("Show", info.Show),
                    new XAttribute("Name", info.Name),
                    new XAttribute("Pic", info.Pic),
                    new XAttribute("Att", info.Att),
                    new XAttribute("Def", info.Def),
                    new XAttribute("Agi", info.Agi),
                    new XAttribute("Luck", info.Luck),
                    new XAttribute("Desc", info.Desc)
                );
        }
        public static XElement CreateConsortiaBuffer(ConsortiaBuffTempInfo info)
        {
            return new XElement("Item",
                    new XAttribute("id", info.id),
                    new XAttribute("name", info.name),
                    new XAttribute("descript", info.descript),
                    new XAttribute("type", info.type),
                    new XAttribute("level", info.level),
                    new XAttribute("value", info.value),
                    new XAttribute("riches", info.riches),
                    new XAttribute("metal", info.metal),
                    new XAttribute("pic", info.pic),
                    new XAttribute("group", info.group)
                );
        }

        public static XElement CreateAccumulAtiveLoginAwards(AccumulAtiveLoginAwardInfo info)
        {
            return new XElement("Item",
                    new XAttribute("ID", info.ID),
                    new XAttribute("Count", info.Type),
                    new XAttribute("RewardItemID", info.RewardItemID),
                    new XAttribute("IsSelect", info.IsSelect),
                    new XAttribute("IsBind", info.IsBind),
                    new XAttribute("RewardItemValid", info.RewardItemValid),
                    new XAttribute("RewardItemCount", info.RewardItemCount),
                    new XAttribute("StrengthenLevel", info.StrengthenLevel),
                    new XAttribute("DefendCompose", info.DefendCompose),
                    new XAttribute("AgilityCompose", info.AgilityCompose),
                    new XAttribute("LuckCompose", info.LuckCompose)
                );
        }
        public static XElement CreateEdictum(EdictumInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("Title", string.IsNullOrEmpty(info.Title) ? "" : info.Title), new XAttribute("BeginDate", info.BeginDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("BeginTime", info.BeginTime.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("EndDate", info.EndDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("EndTime", info.EndTime.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Text", string.IsNullOrEmpty(info.Text) ? "" : info.Text), new XAttribute("IsExist", info.IsExist));
        }

        public static XElement CreateServerInfo(int id, string name, string ip, int port, int state, int mustLevel, int lowestLevel, int online)
        {
            return new XElement("Item", 
                new XAttribute("ID", id), 
                new XAttribute("Name", name),
                new XAttribute("IP", ip),
                new XAttribute("Port", port),
                new XAttribute("State", state), 
                new XAttribute("MustLevel", mustLevel), 
                new XAttribute("LowestLevel", lowestLevel), 
                new XAttribute("Online", online), 
                new XAttribute("Remark", ""));
        }

        public static XElement CreateServerConfig(ServerProperty prop)
        {
            return
                new XElement("Item",
                    new XAttribute("Name", prop.Key),
                    new XAttribute("Value", prop.Value)
                );
        }

        public static XElement CreateMapInfo(MapInfo m)
        {
            return new XElement("Item", new XAttribute("ID", m.ID), new XAttribute("Name", (m.Name == null) ? "" : m.Name), new XAttribute("Description", (m.Description == null) ? "" : m.Description), new XAttribute("ForegroundWidth", m.ForegroundWidth), new XAttribute("ForegroundHeight", m.ForegroundHeight), new XAttribute("BackroundWidht", m.BackroundWidht), new XAttribute("BackroundHeight", m.BackroundHeight), new XAttribute("DeadWidth", m.DeadWidth), new XAttribute("DeadHeight", m.DeadHeight), new XAttribute("Weight", m.Weight), new XAttribute("DragIndex", m.DragIndex), new XAttribute("ForePic", (m.ForePic == null) ? "" : m.ForePic), new XAttribute("BackPic", (m.BackPic == null) ? "" : m.BackPic), new XAttribute("DeadPic", (m.DeadPic == null) ? "" : m.DeadPic), new XAttribute("Pic", (m.Pic == null) ? "" : m.Pic), new XAttribute("BackMusic", (m.BackMusic == null) ? "" : m.BackMusic), new XAttribute("Remark", (m.Remark == null) ? "" : m.Remark), new XAttribute("Type", m.Type));
        }

        public static XElement CreatePveInfo(PveInfo m)
        {
            return
                new XElement("Item", 
                new XAttribute("ID", m.ID),
                new XAttribute("Name", (m.Name == null) ? "" : m.Name),
                new XAttribute("Type", m.Type),
                new XAttribute("LevelLimits", m.LevelLimits),
                new XAttribute("SimpleTemplateIds", (m.SimpleTemplateIds == null) ? "" : m.SimpleTemplateIds),
                new XAttribute("NormalTemplateIds", (m.NormalTemplateIds == null) ? "" : m.NormalTemplateIds),
                new XAttribute("HardTemplateIds", (m.HardTemplateIds == null) ? "" : m.HardTemplateIds),
                new XAttribute("TerrorTemplateIds", (m.TerrorTemplateIds == null) ? "" : m.TerrorTemplateIds),
                new XAttribute("Pic", (m.Pic == null) ? "" : m.Pic),
                new XAttribute("Description", (m.Description == null) ? "" : m.Description),
                new XAttribute("Ordering", m.Ordering),
                new XAttribute("AdviceTips", (m.AdviceTips == null) ? "" : m.AdviceTips),
                new XAttribute("BossFightNeedMoney", m.BossFightNeedMoney == null ? "" : m.BossFightNeedMoney));
        }

        public static XElement CreateStrengthenInfo(StrengthenInfo info)
        {
            return new XElement("Item", 
                new XAttribute("StrengthenLevel", info.StrengthenLevel), 
                new XAttribute("Rock", info.Rock),
                new XAttribute("Rock1", info.Rock1),
                new XAttribute("Rock2", info.Rock2),
                new XAttribute("Rock3", info.Rock3),
                new XAttribute("StoneLevelMin", info.StoneLevelMin)
            );
        }

        public static XElement CreateItemInfo(ItemTemplateInfo info)
        {
            return new XElement("Item", new XAttribute("AddTime", info.AddTime), new XAttribute("Agility", info.Agility), new XAttribute("Attack", info.Attack), new XAttribute("CanCompose", info.CanCompose), new XAttribute("CanDelete", info.CanDelete), new XAttribute("CanDrop", info.CanDrop), new XAttribute("CanEquip", info.CanEquip), new XAttribute("CanStrengthen", info.CanStrengthen), new XAttribute("CanUse", info.CanUse), new XAttribute("CategoryID", info.CategoryID), new XAttribute("Colors", info.Colors), new XAttribute("Defence", info.Defence), new XAttribute("Description", (info.Description == null) ? "" : info.Description), new XAttribute("Level", info.Level), new XAttribute("Luck", info.Luck), new XAttribute("MaxCount", info.MaxCount), new XAttribute("Name", (info.Name == null) ? "" : info.Name), new XAttribute("NeedLevel", info.NeedLevel), new XAttribute("NeedSex", info.NeedSex), new XAttribute("Pic", (info.Pic == null) ? "" : info.Pic), new XAttribute("Data", (info.Data == null) ? "" : info.Data), new XAttribute("Property1", info.Property1), new XAttribute("Property2", info.Property2), new XAttribute("Property3", info.Property3), new XAttribute("Property4", info.Property4), new XAttribute("Property5", info.Property5), new XAttribute("Property6", info.Property6), new XAttribute("Property7", info.Property7), new XAttribute("Property8", info.Property8), new XAttribute("Quality", info.Quality), new XAttribute("Script", (info.Script == null) ? "" : info.Script), new XAttribute("BindType", info.BindType), new XAttribute("FusionType", info.FusionType), new XAttribute("FusionRate", info.FusionRate), new XAttribute("FusionNeedRate", info.FusionNeedRate), new XAttribute("TemplateID", info.TemplateID), new XAttribute("RefineryLevel", info.RefineryLevel), new XAttribute("Hole", info.Hole), new XAttribute("ReclaimValue", info.ReclaimValue), new XAttribute("ReclaimType", info.ReclaimType), new XAttribute("CanRecycle", info.CanRecycle), new XAttribute("SuitId", info.SuitId));
        }

        public static XElement CreateGoodsInfo(ItemInfo info)
        {
            return new XElement("Item", new XAttribute("AgilityCompose", info.AgilityCompose), new XAttribute("AttackCompose", info.AttackCompose), new XAttribute("BeginDate", info.BeginDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Color", (info.Color == null) ? "" : info.Color), new XAttribute("Skin", (info.Skin == null) ? "" : info.Skin), new XAttribute("Count", info.Count), new XAttribute("DefendCompose", info.DefendCompose), new XAttribute("IsBinds", info.IsBinds), new XAttribute("IsUsed", info.IsUsed), new XAttribute("IsJudge", info.IsJudge), new XAttribute("ItemID", info.ItemID), new XAttribute("LuckCompose", info.LuckCompose), new XAttribute("Place", info.Place), new XAttribute("StrengthenLevel", info.StrengthenLevel), new XAttribute("TemplateID", info.TemplateID), new XAttribute("UserID", info.UserID), new XAttribute("BagType", info.BagType), new XAttribute("ValidDate", info.ValidDate), new XAttribute("Hole1", info.Hole1), new XAttribute("Hole2", info.Hole2), new XAttribute("Hole3", info.Hole3), new XAttribute("Hole4", info.Hole4), new XAttribute("Hole5", info.Hole5), new XAttribute("Hole6", info.Hole6));
        }

        public static XElement CreateShopInfo(ShopItemInfo shop)
        {
            return new XElement("Item", new XAttribute("ID", shop.ID), new XAttribute("ShopID", shop.ShopID), new XAttribute("GroupID", shop.GroupID), new XAttribute("TemplateID", shop.TemplateID), new XAttribute("BuyType", shop.BuyType), new XAttribute("IsContinue", shop.IsContinue), new XAttribute("IsBind", shop.IsBind), new XAttribute("IsVouch", shop.IsVouch), new XAttribute("Label", shop.Label), new XAttribute("Beat", shop.Beat), new XAttribute("AUnit", shop.AUnit), new XAttribute("APrice1", shop.APrice1), new XAttribute("AValue1", shop.AValue1), new XAttribute("APrice2", shop.APrice2), new XAttribute("AValue2", shop.AValue2), new XAttribute("APrice3", shop.APrice3), new XAttribute("AValue3", shop.AValue3), new XAttribute("BUnit", shop.BUnit), new XAttribute("BPrice1", shop.BPrice1), new XAttribute("BValue1", shop.BValue1), new XAttribute("BPrice2", shop.BPrice2), new XAttribute("BValue2", shop.BValue2), new XAttribute("BPrice3", shop.BPrice3), new XAttribute("BValue3", shop.BValue3), new XAttribute("CUnit", shop.CUnit), new XAttribute("CPrice1", shop.CPrice1), new XAttribute("CValue1", shop.CValue1), new XAttribute("CPrice2", shop.CPrice2), new XAttribute("CValue2", shop.CValue2), new XAttribute("CPrice3", shop.CPrice3), new XAttribute("CValue3", shop.CValue3), new XAttribute("IsCheap", shop.IsCheap), new XAttribute("LimitCount", shop.LimitCount), new XAttribute("StartDate", shop.StartDate), new XAttribute("EndDate", shop.EndDate));
        }

        public static XElement CreateShopShowInfo(ShopGoodsShowListInfo shop)
        {
            return new XElement("Item", new XAttribute("Type", shop.Type), new XAttribute("ShopId", shop.ShopId));
        }

        public static XElement CreateItemBoxInfo(ItemBoxInfo box)
        {
            return new XElement("Item", new XAttribute("ID", box.ID), new XAttribute("TemplateId", box.TemplateId), new XAttribute("StrengthenLevel", box.StrengthenLevel), new XAttribute("IsBind", box.IsBind), new XAttribute("ItemCount", box.ItemCount), new XAttribute("LuckCompose", box.LuckCompose), new XAttribute("DefendCompose", box.DefendCompose), new XAttribute("AttackCompose", box.AttackCompose), new XAttribute("AgilityCompose", box.AgilityCompose), new XAttribute("ItemValid", box.ItemValid), new XAttribute("IsTips", box.IsTips));
        }

        public static XElement CreateUserBoxInfo(UserBoxInfo box)
        {
            return new XElement("Item", new XAttribute("ID", box.ID), new XAttribute("Type", box.Type), new XAttribute("Level", box.Level), new XAttribute("Condition", box.Condition), new XAttribute("TemplateID", box.TemplateID));
        }

        public static XElement CreateBallInfo(BallInfo b)
        {
            return new XElement("Item", new XAttribute("ID", b.ID), new XAttribute("Power", b.Power), new XAttribute("Radii", b.Radii), new XAttribute("FlyingPartical", (b.FlyingPartical == null) ? "" : b.FlyingPartical), new XAttribute("BombPartical", (b.BombPartical == null) ? "" : b.BombPartical), new XAttribute("Crater", (b.Crater == null) ? "" : b.Crater), new XAttribute("AttackResponse", b.AttackResponse), new XAttribute("IsSpin", b.IsSpin), new XAttribute("SpinV", b.SpinV), new XAttribute("SpinVA", b.SpinVA), new XAttribute("Amount", b.Amount), new XAttribute("Wind", b.Wind), new XAttribute("DragIndex", b.DragIndex), new XAttribute("Weight", b.Weight), new XAttribute("Shake", b.Shake), new XAttribute("ShootSound", (b.ShootSound == null) ? "" : b.ShootSound), new XAttribute("BombSound", (b.BombSound == null) ? "" : b.BombSound), new XAttribute("ActionType", b.ActionType), new XAttribute("Mass", b.Mass));
        }

        public static XElement CreateBallConfigInfo(BallConfigInfo b)
        {
            return new XElement("Item", new XAttribute("TemplateID", b.TemplateID), new XAttribute("Common", b.Common), new XAttribute("CommonAddWound", b.CommonAddWound), new XAttribute("CommonMultiBall", b.CommonMultiBall), new XAttribute("Special", b.Special));
        }

        public static XElement CreateRuneTemplateInfo(RuneTemplateInfo b)
        {
            return new XElement("Rune", new XAttribute("TemplateID", b.TemplateID), new XAttribute("NextTemplateID", b.NextTemplateID), new XAttribute("Name", b.Name), new XAttribute("BaseLevel", b.BaseLevel), new XAttribute("MaxLevel", b.MaxLevel), new XAttribute("Type1", b.Type1), new XAttribute("Attribute1", b.Attribute1), new XAttribute("Turn1", b.Turn1), new XAttribute("Rate1", b.Rate1), new XAttribute("Type2", b.Type2), new XAttribute("Attribute2", b.Attribute2), new XAttribute("Turn2", b.Turn2), new XAttribute("Rate2", b.Rate2), new XAttribute("Type3", b.Type3), new XAttribute("Attribute3", b.Attribute3), new XAttribute("Turn3", b.Turn3), new XAttribute("Rate3", b.Rate3));
        }

        public static XElement CreateCategoryInfo(CategoryInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("Name", (info.Name == null) ? "" : info.Name), new XAttribute("Place", info.Place), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark));
        }

        public static XElement CreateUserLoginList(PlayerInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), 
                new XAttribute("UserName", (info.UserName == null) ? "" : info.UserName), 
                new XAttribute("NickName", (info.NickName == null) ? "" : info.NickName), 
                new XAttribute("Grade", info.Grade), 
                new XAttribute("Repute", info.Repute), 
                new XAttribute("Sex", info.Sex), 
                new XAttribute("WinCount", info.Win),
                new XAttribute("TotalCount", info.Total),
                new XAttribute("ConsortiaName", info.ConsortiaName), 
                new XAttribute("Rename", info.Rename), 
                new XAttribute("IsVIP", info.typeVIP > 0), 
                new XAttribute("VIPLevel", info.VIPLevel),
                new XAttribute("ConsortiaRename", info.ConsortiaRename ? (info.NickName == info.ChairmanName) : info.ConsortiaRename), 
                new XAttribute("EscapeCount", info.Escape), 
                new XAttribute("IsFirst", info.IsFirst),
                new XAttribute("LastDate", DateTime.Now.AddDays(-1.0)));
        }

        public static XElement CreateQuestInfo(QuestInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("QuestID", info.QuestID), new XAttribute("Title", info.Title), new XAttribute("Detail", info.Detail), new XAttribute("Objective", info.Objective), new XAttribute("NeedMinLevel", info.NeedMinLevel), new XAttribute("NeedMaxLevel", info.NeedMaxLevel), new XAttribute("PreQuestID", info.PreQuestID), new XAttribute("NextQuestID", info.NextQuestID), new XAttribute("IsOther", info.IsOther), new XAttribute("CanRepeat", info.CanRepeat), new XAttribute("RepeatInterval", info.RepeatInterval), new XAttribute("RepeatMax", info.RepeatMax), new XAttribute("RewardGP", info.RewardGP), new XAttribute("RewardGold", info.RewardGold), new XAttribute("RewardGiftToken", info.RewardGiftToken), new XAttribute("RewardOffer", info.RewardOffer), new XAttribute("RewardRiches", info.RewardRiches), new XAttribute("RewardBuffID", info.RewardBuffID), new XAttribute("RewardBuffDate", info.RewardBuffDate), new XAttribute("RewardMoney", info.RewardMoney), new XAttribute("Rands", info.Rands), new XAttribute("RandDouble", info.RandDouble), new XAttribute("TimeMode", info.TimeMode), new XAttribute("StartDate", info.StartDate), new XAttribute("EndDate", info.EndDate), new XAttribute("MapID", info.MapID), new XAttribute("AutoEquip", info.AutoEquip), new XAttribute("RewardMedal", info.RewardMedal), new XAttribute("Rank", info.Rank), new XAttribute("StarLev", info.StarLev), new XAttribute("NotMustCount", info.NotMustCount));
        }

        public static XElement CreateQuestCondiction(QuestConditionInfo info)
        {
            return new XElement("Item_Condiction", new XAttribute("QuestID", info.QuestID), new XAttribute("CondictionID", info.CondictionID), new XAttribute("CondictionTitle", info.CondictionTitle), new XAttribute("CondictionType", info.CondictionType), new XAttribute("Para1", info.Para1), new XAttribute("Para2", info.Para2), new XAttribute("isOpitional", info.isOpitional));
        }

        public static XElement CreateQuestGoods(QuestAwardInfo info)
        {
            return new XElement("Item_Good", new XAttribute("QuestID", info.QuestID), new XAttribute("RewardItemID", info.RewardItemID), new XAttribute("IsSelect", info.IsSelect), new XAttribute("RewardItemValid", info.RewardItemValid), new XAttribute("RewardItemCount", info.RewardItemCount), new XAttribute("StrengthenLevel", info.StrengthenLevel), new XAttribute("AttackCompose", info.AttackCompose), new XAttribute("DefendCompose", info.DefendCompose), new XAttribute("AgilityCompose", info.AgilityCompose), new XAttribute("LuckCompose", info.LuckCompose), new XAttribute("IsCount", info.IsCount), new XAttribute("IsBind", info.IsBind));
        }

        public static XElement CreateQuestDataInfo(QuestDataInfo info)
        {
            return new XElement("Item", new XAttribute("CompletedDate", info.CompletedDate), new XAttribute("IsComplete", info.IsComplete), new XAttribute("Condition1", info.Condition1), new XAttribute("Condition2", info.Condition2), new XAttribute("Condition3", info.Condition3), new XAttribute("Condition4", info.Condition4), new XAttribute("QuestID", info.QuestID), new XAttribute("UserID", info.UserID), new XAttribute("RepeatFinish", info.RepeatFinish));
        }

        public static XElement CreateMapServer(ServerMapInfo info)
        {
            return new XElement("Item", new XAttribute("ServerID", info.ServerID), new XAttribute("OpenMap", info.OpenMap), new XAttribute("IsSpecial", info.IsSpecial));
        }

        public static XElement CreateActiveInfo(ActiveInfo info)
        {
            XName name = "Item";
            object[] objArray = new object[17]
            {
            new XAttribute("ActiveID", info.ActiveID),
            new XAttribute("Description", (info.Description == null) ? "" : info.Description),
            new XAttribute("Content", (info.Content == null) ? "" : info.Content),
            new XAttribute("AwardContent", (info.AwardContent == null) ? "" : info.AwardContent),
            new XAttribute("HasKey", info.HasKey),
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null
            };
            int index1 = 5;
            XName name2 = "EndDate";
            string str1 = ((!info.EndDate.HasValue) ? "" : info.EndDate.Value.ToString("yyyy-MM-dd HH:mm:ss"));
            XAttribute xattribute1 = (XAttribute)(objArray[index1] = new XAttribute(name2, str1));
            objArray[6] = new XAttribute("IsOnly", info.IsOnly);
            int index2 = 7;
            XName name3 = "StartDate";
            string str2 = (string.IsNullOrEmpty(info.StartDate.ToString()) ? "" : info.StartDate.ToString("yyyy-MM-dd HH:mm:ss"));
            XAttribute xattribute2 = (XAttribute)(objArray[index2] = new XAttribute(name3, str2));
            objArray[8] = new XAttribute("Title", (info.Title == null) ? "" : info.Title);
            objArray[9] = new XAttribute("Type", info.Type);
            objArray[10] = new XAttribute("ActiveType", "0");
            objArray[11] = new XAttribute("IsAdvance", false);
            objArray[12] = new XAttribute("GoodsExchangeTypes", "");
            objArray[13] = new XAttribute("GoodsExchangeNum", "");
            objArray[14] = new XAttribute("limitType", "");
            objArray[15] = new XAttribute("limitValue", "");
            objArray[16] = new XAttribute("ActionTimeContent", (info.ActionTimeContent == null) ? "" : info.ActionTimeContent);
            return new XElement(name, objArray);
        }

        public static XElement CreateAuctionInfo(AuctionInfo info)
        {
            return new XElement("Item", new XAttribute("AuctionID", info.AuctionID), new XAttribute("AuctioneerID", info.AuctioneerID), new XAttribute("AuctioneerName", (info.AuctioneerName == null) ? "" : info.AuctioneerName), new XAttribute("BeginDate", info.BeginDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("BuyerID", info.BuyerID), new XAttribute("BuyerName", (info.BuyerName == null) ? "" : info.BuyerName), new XAttribute("ItemID", info.ItemID), new XAttribute("Mouthful", info.Mouthful), new XAttribute("PayType", info.PayType), new XAttribute("Price", info.Price), new XAttribute("Rise", info.Rise), new XAttribute("ValidDate", info.ValidDate));
        }

        public static XElement CreateConsortiaInfo(ConsortiaInfo info)
        {
            return new XElement("Item", new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("BuildDate", info.BuildDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("CelebCount", info.CelebCount), new XAttribute("ChairmanID", info.ChairmanID), new XAttribute("ChairmanName", (info.ChairmanName == null) ? "" : info.ChairmanName), new XAttribute("ChairmanTypeVIP", 0), new XAttribute("ChairmanVIPLevel", 0), new XAttribute("ConsortiaName", (info.ConsortiaName == null) ? "" : info.ConsortiaName), new XAttribute("CreatorID", info.CreatorID), new XAttribute("CreatorName", (info.CreatorName == null) ? "" : info.CreatorName), new XAttribute("Description", (info.Description == null) ? "" : info.Description), new XAttribute("Honor", info.Honor), new XAttribute("IP", info.IP), new XAttribute("Level", info.Level), new XAttribute("MaxCount", info.MaxCount), new XAttribute("Placard", (info.Placard == null) ? "" : info.Placard), new XAttribute("Repute", info.Repute), new XAttribute("Count", info.Count), new XAttribute("Riches", info.Riches), new XAttribute("FightPower", info.FightPower), new XAttribute("DeductDate", info.DeductDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("AddDayHonor", info.AddDayHonor), new XAttribute("AddDayRiches", info.AddDayRiches), new XAttribute("AddWeekHonor", info.AddWeekHonor), new XAttribute("AddWeekRiches", info.AddWeekRiches), new XAttribute("LastDayRiches", info.LastDayRiches), new XAttribute("OpenApply", info.OpenApply), new XAttribute("StoreLevel", info.StoreLevel), new XAttribute("SmithLevel", info.SmithLevel), new XAttribute("ShopLevel", info.ShopLevel), new XAttribute("BufferLevel", info.SkillLevel), new XAttribute("ConsortiaGiftGp", 0), new XAttribute("ConsortiaAddDayGiftGp", 0), new XAttribute("ConsortiaAddWeekGiftGp", 0), new XAttribute("Port", info.Port), new XAttribute("IsVoting", false), new XAttribute("VoteRemainDay", 3), new XAttribute("CharmGP", 0), new XAttribute("BadgeBuyTime", info.BadgeBuyTime), new XAttribute("BadgeID", info.BadgeID), new XAttribute("ValidDate", info.ValidDate));
        }

        public static XElement CreateConsortiaApplyUserInfo(ConsortiaApplyUserInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("ApplyDate", info.ApplyDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("ConsortiaName", (info.ConsortiaName == null) ? "" : info.ConsortiaName), new XAttribute("Remark", info.Remark), new XAttribute("UserID", info.UserID), new XAttribute("UserName", (info.UserName == null) ? "" : info.UserName), new XAttribute("UserLevel", info.UserLevel), new XAttribute("Win", info.Win), new XAttribute("Total", info.Total), new XAttribute("Repute", info.Repute));
        }

        public static XElement CreateConsortiaInviteUserInfo(ConsortiaInviteUserInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("CelebCount", info.CelebCount), new XAttribute("ChairmanName", (info.ChairmanName == null) ? "" : info.ChairmanName), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("ConsortiaName", (info.ConsortiaName == null) ? "" : info.ConsortiaName), new XAttribute("Count", info.Count), new XAttribute("Honor", info.Honor), new XAttribute("InviteDate", info.InviteDate), new XAttribute("InviteID", info.InviteID), new XAttribute("InviteName", (info.InviteName == null) ? "" : info.InviteName), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark), new XAttribute("Repute", info.Repute), new XAttribute("UserID", info.UserID), new XAttribute("UserName", (info.UserName == null) ? "" : info.UserName));
        }

        public static XElement CreateConsortiaUserInfo(ConsortiaUserInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("DutyID", info.DutyID), new XAttribute("DutyName", (info.DutyName == null) ? "" : info.DutyName), new XAttribute("GP", info.GP), new XAttribute("Level", info.Level), new XAttribute("Grade", info.Grade), new XAttribute("Right", info.Right), new XAttribute("DutyLevel", info.Level), new XAttribute("Offer", info.Offer), new XAttribute("RatifierID", info.RatifierID), new XAttribute("RatifierName", (info.RatifierName == null) ? "" : info.RatifierName), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark), new XAttribute("Repute", info.Repute), new XAttribute("State", (info.State == 1) ? 1 : 0), new XAttribute("UserID", info.UserID), new XAttribute("Hide", info.Hide), new XAttribute("Colors", (info.Colors == null) ? "" : info.Colors), new XAttribute("Skin", (info.Skin == null) ? "" : info.Skin), new XAttribute("Style", info.Style), new XAttribute("LastDate", info.LastDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Sex", info.Sex), new XAttribute("IsBanChat", info.IsBanChat), new XAttribute("WinCount", info.Win), new XAttribute("TotalCount", info.Total), new XAttribute("EscapeCount", info.Escape), new XAttribute("RichesOffer", info.RichesOffer), new XAttribute("RichesRob", info.RichesRob), new XAttribute("Nimbus", info.Nimbus), new XAttribute("LoginName", (info.LoginName == null) ? "" : info.LoginName), new XAttribute("UserName", (info.UserName == null) ? "" : info.UserName), new XAttribute("FightPower", info.FightPower), new XAttribute("Rank", info.honor), new XAttribute("AchievementPoint", info.AchievementPoint), new XAttribute("IsDiplomatism", true), new XAttribute("IsDownGrade", true), new XAttribute("IsEditorPlacard", true), new XAttribute("IsEditorDescription", true), new XAttribute("IsExpel", true), new XAttribute("IsEditorUser", true), new XAttribute("IsInvite", false), new XAttribute("IsManageDuty", true), new XAttribute("IsUpGrade", false), new XAttribute("typeVIP", info.typeVIP), new XAttribute("VIPLevel", info.VIPLevel), new XAttribute("IsRatify", true), new XAttribute("IsChat", true), new XAttribute("TotalRichesOffer", info.UseOffer));
        }

        public static XElement CreateConsortiaIMInfo(ConsortiaUserInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("DutyID", info.DutyID), new XAttribute("DutyName", (info.DutyName == null) ? "" : info.DutyName), new XAttribute("GP", info.GP), new XAttribute("Grade", info.Grade), new XAttribute("Level", info.Level), new XAttribute("Offer", info.Offer), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark), new XAttribute("Repute", info.Repute), new XAttribute("State", (info.State == 1) ? 1 : 0), new XAttribute("UserID", info.UserID), new XAttribute("Hide", info.Hide), new XAttribute("Colors", (info.Colors == null) ? "" : info.Colors), new XAttribute("Skin", (info.Skin == null) ? "" : info.Skin), new XAttribute("Style", info.Style), new XAttribute("LastDate", info.LastDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Sex", info.Sex), new XAttribute("LoginName", info.LoginName), new XAttribute("NickName", (info.UserName == null) ? "" : info.UserName));
        }

        public static XElement CreateConsortiaDutyInfo(ConsortiaDutyInfo info)
        {
            return new XElement("Item", new XAttribute("DutyID", info.DutyID), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("DutyName", (info.DutyName == null) ? "" : info.DutyName), new XAttribute("Right", info.Right), new XAttribute("Level", info.Level));
        }

        public static XElement CreateConsortiaApplyAllyInfo(ConsortiaApplyAllyInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("CelebCount", info.CelebCount), new XAttribute("ChairmanName", (info.ChairmanName == null) ? "" : info.ChairmanName), new XAttribute("ConsortiaID", info.Consortia1ID), new XAttribute("ConsortiaName", (info.ConsortiaName == null) ? "" : info.ConsortiaName), new XAttribute("Count", info.Count), new XAttribute("Date", info.Date.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Honor", info.Honor), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark), new XAttribute("Level", info.Level), new XAttribute("Description", (info.Description == null) ? "" : info.Description), new XAttribute("Repute", info.Repute));
        }

        public static XElement CreateConsortiaAllyInfo(ConsortiaAllyInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("ChairmanName", (info.ChairmanName1 == null) ? "" : info.ChairmanName1), new XAttribute("ConsortiaID", info.Consortia1ID), new XAttribute("ConsortiaName", (info.ConsortiaName1 == null) ? "" : info.ConsortiaName1), new XAttribute("Count", info.Count1), new XAttribute("Honor", info.Honor1), new XAttribute("State", info.State), new XAttribute("Date", info.Date.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Level", info.Level1), new XAttribute("IsApply", info.IsApply), new XAttribute("Description", info.Description1), new XAttribute("Riches", info.Riches1), new XAttribute("Repute", info.Repute1));
        }

        public static XElement CreateConsortiaEventInfo(ConsortiaEventInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("Date", info.Date.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Type", info.Type), new XAttribute("Remark", DateTime.Now.ToString()), new XAttribute("NickName", info.NickName), new XAttribute("EventValue", info.EventValue), new XAttribute("ManagerName", info.ManagerName));
        }

        public static XElement CreateConsortiLevelInfo(ConsortiaLevelInfo info)
        {
            return new XElement("Item", new XAttribute("Level", info.Level), new XAttribute("Count", info.Count), new XAttribute("Deduct", info.Deduct), new XAttribute("NeedGold", info.NeedGold), new XAttribute("NeedItem", info.NeedItem), new XAttribute("Reward", info.Reward), new XAttribute("ShopRiches", info.ShopRiches), new XAttribute("SmithRiches", info.SmithRiches), new XAttribute("StoreRiches", info.StoreRiches), new XAttribute("BufferRiches", info.BufferRiches), new XAttribute("Riches", info.Riches));
        }

        public static XElement CreateEliteMatchPlayersList(PlayerInfo info, int rank)
        {
            return new XElement("Item", new XAttribute("PlayerID", info.ID), new XAttribute("PlayerName", (info.NickName == null) ? "" : info.NickName), new XAttribute("PlayerScore", info.EliteScore), new XAttribute("PlayerRank", rank));
        }

        public static XElement CreateCelebInfo(PlayerInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("UserName", (info.UserName == null) ? "" : info.UserName), new XAttribute("NickName", (info.NickName == null) ? "" : info.NickName), new XAttribute("typeVIP", info.typeVIP), new XAttribute("VIPLevel", info.VIPLevel), new XAttribute("Grade", info.Grade), new XAttribute("Colors", (info.Colors == null) ? "" : info.Colors), new XAttribute("Skin", (info.Skin == null) ? "" : info.Skin), new XAttribute("Sex", info.Sex), new XAttribute("Style", (info.Style == null) ? "" : info.Style), new XAttribute("ConsortiaName", (info.ConsortiaName == null) ? "" : info.ConsortiaName), new XAttribute("Hide", info.Hide), new XAttribute("Offer", info.Offer), new XAttribute("ReputeOffer", info.ReputeOffer), new XAttribute("ConsortiaHonor", info.ConsortiaHonor), new XAttribute("ConsortiaLevel", info.ConsortiaLevel), new XAttribute("StoreLevel", info.StoreLevel), new XAttribute("ShopLevel", info.ShopLevel), new XAttribute("SmithLevel", info.SmithLevel), new XAttribute("ConsortiaRepute", info.ConsortiaRepute), new XAttribute("WinCount", info.Win), new XAttribute("TotalCount", info.Total), new XAttribute("EscapeCount", info.Escape), new XAttribute("Repute", info.Repute), new XAttribute("AddDayGP", info.AddDayGP), new XAttribute("AddDayOffer", info.AddDayOffer), new XAttribute("AddWeekGP", info.AddWeekGP), new XAttribute("AddWeekOffer", info.AddWeekOffer), new XAttribute("ConsortiaRiches", info.ConsortiaRiches), new XAttribute("Nimbus", info.Nimbus), new XAttribute("GP", info.GP), new XAttribute("FightPower", info.FightPower), new XAttribute("AchievementPoint", info.AchievementPoint), new XAttribute("Rank", ""), new XAttribute("AddDayAchievementPoint", 0), new XAttribute("AddWeekAchievementPoint", 0), new XAttribute("GiftGp", 0), new XAttribute("GiftLevel", 1), new XAttribute("AddDayGiftGp", 0), new XAttribute("AddWeekGiftGp", 0), new XAttribute("ApprenticeshipState", 0), new XAttribute("AddWeekLeagueScore", info.AddWeekLeagueScore));
        }

        public static XElement CreateBestEquipInfo(BestEquipInfo info)
        {
            return new XElement("Item", new XAttribute("Date", info.Date.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("GP", info.GP), new XAttribute("Grade", info.Grade), new XAttribute("ItemName", (info.ItemName == null) ? "" : info.ItemName), new XAttribute("NickName", (info.NickName == null) ? "" : info.NickName), new XAttribute("Sex", info.Sex), new XAttribute("Strengthenlevel", info.Strengthenlevel), new XAttribute("Type", (info.UserName == null) ? "" : info.UserName));
        }

        public static XElement CreateMailInfo(MailInfo info, string nodeName)
        {
            DateTime.Now.Subtract(info.SendTime);
            return new XElement(nodeName, new XAttribute("ID", info.ID), new XAttribute("Title", info.Title), new XAttribute("Content", info.Content), new XAttribute("Sender", info.Sender), new XAttribute("Receiver", info.Receiver), new XAttribute("SendTime", info.SendTime.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("ValidDate", info.ValidDate), new XAttribute("Gold", info.Gold), new XAttribute("Money", info.Money), new XAttribute("Annex1ID", (info.Annex1 == null) ? "" : info.Annex1), new XAttribute("Annex2ID", (info.Annex2 == null) ? "" : info.Annex2), new XAttribute("Annex3ID", (info.Annex3 == null) ? "" : info.Annex3), new XAttribute("Annex4ID", (info.Annex4 == null) ? "" : info.Annex4), new XAttribute("Annex5ID", (info.Annex5 == null) ? "" : info.Annex5), new XAttribute("Annex1Name", (info.Annex1Name == null) ? "" : info.Annex1Name), new XAttribute("Annex2Name", (info.Annex2Name == null) ? "" : info.Annex2Name), new XAttribute("Annex3Name", (info.Annex3Name == null) ? "" : info.Annex3Name), new XAttribute("Annex4Name", (info.Annex4Name == null) ? "" : info.Annex4Name), new XAttribute("Annex5Name", (info.Annex5Name == null) ? "" : info.Annex5Name), new XAttribute("AnnexRemark", (info.AnnexRemark == null) ? "" : info.AnnexRemark), new XAttribute("Type", info.Type), new XAttribute("IsRead", info.IsRead));
        }

        public static XElement CreateBuffInfo(BufferInfo info)
        {
            return new XElement("Item", new XAttribute("BeginDate", info.BeginDate.ToString("yyyy-MM-dd HH:mm:ss")), new XAttribute("Data", (info.Data == null) ? "" : info.Data), new XAttribute("IsExist", info.IsExist), new XAttribute("Type", info.Type), new XAttribute("UserID", info.UserID), new XAttribute("ValidDate", info.ValidDate), new XAttribute("Value", info.Value));
        }

        public static XElement CreateMarryInfo(MarryInfo info)
        {
            return new XElement("Info", new XAttribute("ID", info.ID), new XAttribute("UserID", info.UserID), new XAttribute("IsPublishEquip", info.IsPublishEquip), new XAttribute("Introduction", info.Introduction), new XAttribute("NickName", info.NickName), new XAttribute("IsConsortia", info.IsConsortia), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("Sex", info.Sex), new XAttribute("Win", info.Win), new XAttribute("Total", info.Total), new XAttribute("Escape", info.Escape), new XAttribute("GP", info.GP), new XAttribute("Honor", info.Honor), new XAttribute("Style", info.Style), new XAttribute("Colors", info.Colors), new XAttribute("Hide", info.Hide), new XAttribute("Grade", info.Grade), new XAttribute("State", info.State), new XAttribute("Repute", info.Repute), new XAttribute("Skin", info.Skin), new XAttribute("Offer", info.Offer), new XAttribute("IsMarried", info.IsMarried), new XAttribute("ConsortiaName", info.ConsortiaName), new XAttribute("DutyName", info.DutyName), new XAttribute("Nimbus", info.Nimbus), new XAttribute("FightPower", info.FightPower));
        }

        public static XElement CreateUserApprenticeshipInfo(PlayerInfo info)
        {
            return new XElement("Item", new XAttribute("UserID", info.ID), new XAttribute("NickName", info.NickName), new XAttribute("typeVIP", info.typeVIP), new XAttribute("VIPLevel", info.VIPLevel), new XAttribute("Skin", info.Skin), new XAttribute("Sex", info.Sex), new XAttribute("Grade", info.Grade), new XAttribute("Hide", info.Hide), new XAttribute("ConsortiaName", info.ConsortiaName), new XAttribute("WinCount", info.Win), new XAttribute("TotalCount", info.Total), new XAttribute("EscapeCount", info.Escape), new XAttribute("Offer", info.Offer), new XAttribute("State", info.State), new XAttribute("Repute", info.Repute), new XAttribute("DutyName", info.DutyName), new XAttribute("AchievementPoint", info.AchievementPoint), new XAttribute("Rank", info.Honor), new XAttribute("FightPower", info.FightPower), new XAttribute("ApprenticeshipState", info.apprenticeshipState), new XAttribute("GraduatesCount", info.graduatesCount), new XAttribute("IsMarried", info.IsMarried), new XAttribute("HonourOfMaster", info.honourOfMaster), new XAttribute("Style", info.Style), new XAttribute("Colors", info.Colors), new XAttribute("LastDate", info.LastDate.ToString()));
        }

        public static XElement CreateApprenticeShipInfo(PlayerInfo info)
        {
            return new XElement("Info", new XAttribute("UserID", info.ID), new XAttribute("ApplyFor", false), new XAttribute("IsPublishEquip", true), new XAttribute("NickName", info.NickName), new XAttribute("typeVIP", info.typeVIP), new XAttribute("VIPLevel", info.VIPLevel), new XAttribute("IsConsortia", info.IsConsortia), new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("Sex", info.Sex), new XAttribute("Win", info.Win), new XAttribute("Total", info.Total), new XAttribute("Escape", info.Escape), new XAttribute("GP", info.GP), new XAttribute("Honor", info.Honor), new XAttribute("Style", info.Style), new XAttribute("Colors", info.Colors), new XAttribute("Hide", info.Hide), new XAttribute("Grade", info.Grade), new XAttribute("State", info.State), new XAttribute("Repute", info.Repute), new XAttribute("Skin", info.Skin), new XAttribute("Offer", info.Offer), new XAttribute("IsMarried", info.IsMarried), new XAttribute("ConsortiaName", info.ConsortiaName), new XAttribute("DutyName", info.DutyName), new XAttribute("Nimbus", info.Nimbus), new XAttribute("FightPower", info.FightPower), new XAttribute("AchievementPoint", info.AchievementPoint), new XAttribute("Rank", info.Honor), new XAttribute("ApprenticeshipState", info.apprenticeshipState), new XAttribute("GraduatesCount", info.graduatesCount), new XAttribute("HonourOfMaster", info.honourOfMaster), new XAttribute("SpouseID", info.SpouseID), new XAttribute("SpouseName", info.SpouseName), new XAttribute("BadgeID", info.badgeID), new XAttribute("BadgeBuyTime", DateTime.Now.ToString()), new XAttribute("ValidDate", 0));
        }

        public static XElement CreateActiveInfo(DailyAwardInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("Count", info.Count), new XAttribute("CountRemark", (info.CountRemark == null) ? "" : info.CountRemark), new XAttribute("IsBinds", info.IsBinds), new XAttribute("Remark", (info.Remark == null) ? "" : info.Remark), new XAttribute("Sex", info.Sex), new XAttribute("TemplateID", info.TemplateID), new XAttribute("Type", info.Type), new XAttribute("ValidDate", info.ValidDate), new XAttribute("GetWay", info.GetWay), new XAttribute("AwardDays", info.AwardDays));
        }

        public static XElement CreateConsortiaEquipControlInfo(ConsortiaEquipControlInfo info)
        {
            return new XElement("Item", new XAttribute("ConsortiaID", info.ConsortiaID), new XAttribute("Level", info.Level), new XAttribute("Riches", info.Riches), new XAttribute("Type", info.Type));
        }

        public static XElement CreatNPCInfo(NpcInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("Name", info.Name), new XAttribute("Level", info.Level), new XAttribute("Camp", info.Camp), new XAttribute("Type", info.Type), new XAttribute("Blood", info.Blood), new XAttribute("MoveMin", info.MoveMin), new XAttribute("MoveMax", info.MoveMax), new XAttribute("BaseDamage", info.BaseDamage), new XAttribute("BaseGuard", info.BaseGuard), new XAttribute("Defence", info.Defence), new XAttribute("Agility", info.Agility), new XAttribute("Lucky", info.Lucky), new XAttribute("ModelID", info.ModelID), new XAttribute("ResourcesPath", info.ResourcesPath), new XAttribute("DropRate", info.DropRate), new XAttribute("Experience", info.Experience), new XAttribute("Delay", info.Delay), new XAttribute("Immunity", info.Immunity), new XAttribute("Alert", info.Alert), new XAttribute("Range", info.Range), new XAttribute("Preserve", info.Preserve), new XAttribute("Script", info.Script), new XAttribute("FireX", info.FireX), new XAttribute("FireY", info.FireY), new XAttribute("DropId", info.DropId), new XAttribute("MagicAttack", 0), new XAttribute("MagicDefence", 0));
        }

        public static XElement CreateCardUpdateInfo(CardUpdateInfo info)
        {
            return new XElement("Item", new XAttribute("Id", info.Id), new XAttribute("Level", info.Level), new XAttribute("Attack", info.Attack), new XAttribute("Defend", info.Defend), new XAttribute("Agility", info.Agility), new XAttribute("Lucky", info.Lucky), new XAttribute("Guard", info.Guard), new XAttribute("Damage", info.Damage));
        }

        public static XElement CreateCardUpdateCondition(CardUpdateConditionInfo info)
        {
            return new XElement("Item", new XAttribute("Level", info.Level), new XAttribute("Exp", info.Exp), new XAttribute("MinExp", info.MinExp), new XAttribute("MaxExp", info.MaxExp), new XAttribute("UpdateCardCount", info.UpdateCardCount), new XAttribute("ResetCardCount", info.ResetCardCount), new XAttribute("ResetMoney", info.ResetMoney));
        }

        public static XElement CreatePetSkillTemplate(PetSkillTemplateInfo info)
        {
            return new XElement("item", new XAttribute("PetTemplateID", info.PetTemplateID), new XAttribute("KindID", info.KindID), new XAttribute("GetType", 1), new XAttribute("SkillID", info.SkillID), new XAttribute("SkillBookID", info.SkillBookID), new XAttribute("MinLevel", info.MinLevel), new XAttribute("DeleteSkillIDs", info.DeleteSkillIDs));
        }

        public static XElement CreatePetSkillElement(PetSkillElementInfo info)
        {
            return new XElement("item", new XAttribute("ID", info.ID), new XAttribute("Name", info.Name), new XAttribute("EffectPic", info.EffectPic), new XAttribute("Description", info.Description), new XAttribute("Pic", info.Pic));
        }

        public static XElement CreatePetSkillInfo(PetSkillInfo info)
        {
            return new XElement("item", new XAttribute("ID", info.ID), new XAttribute("Name", info.Name), new XAttribute("ElementIDs", info.ElementIDs), new XAttribute("Description", info.Description), new XAttribute("BallType", info.BallType), new XAttribute("NewBallID", info.NewBallID), new XAttribute("CostMP", info.CostMP), new XAttribute("Pic", info.Pic), new XAttribute("Action", info.Action), new XAttribute("EffectPic", info.EffectPic), new XAttribute("Delay", info.Delay), new XAttribute("ColdDown", info.ColdDown), new XAttribute("GameType", info.GameType), new XAttribute("Probability", info.Probability));
        }

        public static XElement CreatePetTemplate(PetTemplateInfo info)
        {
            return new XElement("item", new XAttribute("TemplateID", info.TemplateID), new XAttribute("Name", info.Name), new XAttribute("KindID", info.KindID), new XAttribute("Description", info.Description), new XAttribute("Pic", info.Pic), new XAttribute("RareLevel", info.RareLevel), new XAttribute("MP", info.MP), new XAttribute("StarLevel", info.StarLevel), new XAttribute("GameAssetUrl", info.GameAssetUrl), new XAttribute("HighAgility", info.HighAgility), new XAttribute("HighAgilityGrow", info.HighAgilityGrow), new XAttribute("HighAttack", info.HighAttack), new XAttribute("HighAttackGrow", info.HighAttackGrow), new XAttribute("HighBlood", info.HighBlood), new XAttribute("HighBloodGrow", info.HighBloodGrow), new XAttribute("HighDamage", info.HighDamage), new XAttribute("HighDamageGrow", info.HighDamageGrow), new XAttribute("HighDefence", info.HighDefence), new XAttribute("HighDefenceGrow", info.HighDefenceGrow), new XAttribute("HighGuard", info.HighGuard), new XAttribute("HighGuardGrow", info.HighGuardGrow), new XAttribute("HighLuck", info.HighLuck), new XAttribute("HighLuckGrow", info.HighLuckGrow));
        }


        public static XElement CreatePetMoePropertyItems(PetMoePropertyInfo info)
        {
            return new XElement("Item", new XAttribute("Level", info.Level), new XAttribute("Attack", info.Attack), new XAttribute("Lucky", info.Lucky), new XAttribute("Agility", info.Agility), new XAttribute("Blood", info.Blood), new XAttribute("Defence", info.Defence), new XAttribute("Guard", info.Guard), new XAttribute("Exp", info.Exp));
        }

        public static XElement CreateShopCheapItems(ShopItemInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("TemplateID", info.TemplateID), new XAttribute("AUnit", info.AUnit), new XAttribute("APrice", info.APrice1), new XAttribute("AValue", info.AValue1), new XAttribute("BUnit", info.BUnit), new XAttribute("BPrice", info.BPrice1), new XAttribute("BValue", info.BValue1), new XAttribute("CUnit", info.CUnit), new XAttribute("CPrice", info.CPrice1), new XAttribute("CValue", info.CValue1), new XAttribute("StartDate", info.StartDate), new XAttribute("EndDate", info.EndDate), new XAttribute("BuyType", info.BuyType));
        }

        public static XElement CreateUserRankDateItems(UserRankDateInfo info)
        {
            return new XElement("Item", new object[]
            {
                new XAttribute("UserID", info.UserID),
                new XAttribute("ConsortiaID", info.ConsortiaID),
                new XAttribute("FightPower", info.FightPower),
                new XAttribute("PrevFightPower", info.PrevFightPower),
                new XAttribute("GP", info.GP),
                new XAttribute("PrevGP", info.PrevGP),
                new XAttribute("AchievementPoint", info.AchievementPoint),
                new XAttribute("PrevAchievementPoint", info.PrevAchievementPoint),
                new XAttribute("charmGP", info.charmGP),
                new XAttribute("PrecharmGP", info.PrecharmGP),
                new XAttribute("LeagueAddWeek", info.LeagueAddWeek),
                new XAttribute("PrevLeagueAddWeek", info.PrevLeagueAddWeek),
                new XAttribute("ConsortiaFightPower", info.ConsortiaFightPower),
                new XAttribute("ConsortiaPrevFightPower", info.ConsortiaPrevFightPower),
                new XAttribute("ConsortiaLevel", info.ConsortiaLevel),
                new XAttribute("ConsortiaPrevLevel", info.ConsortiaPrevLevel),
                new XAttribute("ConsortiaRiches", info.ConsortiaRiches),
                new XAttribute("ConsortiaPrevRiches", info.ConsortiaPrevRiches),
                new XAttribute("ConsortiacharmGP", info.ConsortiacharmGP),
                new XAttribute("ConsortiaPrevcharmGP", info.ConsortiaPrevcharmGP)
            });
        }

        public static XElement CreateActivitySystemItems(ActivitySystemItemInfo info)
        {
            return new XElement("Item",
                new XAttribute("ActivityType", info.ActivityType),
                new XAttribute("Quality", info.Quality),
                new XAttribute("TemplateID", info.TemplateID),
                new XAttribute("ValidDate", info.ValidDate),
                new XAttribute("Count", info.Count),
                new XAttribute("IsBind", info.IsBind),
                new XAttribute("StrengthLevel", info.StrengthLevel),
                new XAttribute("AttackCompose", info.AttackCompose),
                new XAttribute("DefendCompose", info.DefendCompose),
                new XAttribute("AgilityCompose", info.AgilityCompose),
                new XAttribute("LuckCompose", info.LuckCompose)
                );
        }

        public static XElement LuckstarActivityRank(LuckstarActivityRankInfo info)
        {
            return new XElement("rankInfo"
                , new XAttribute("rank", info.rank)
                , new XAttribute("useStarNum", info.useStarNum)
                , new XAttribute("nickName", info.nickName)
                , new XAttribute("isVip", info.isVip));
        }

        public static XElement CreateAchievement(AchievementInfo info)
        {
            return new XElement("Item",
                new XAttribute("ID", info.ID),
                new XAttribute("AchievementPoint", info.AchievementPoint),
                new XAttribute("AchievementType", info.AchievementType),
                new XAttribute("CanHide", info.CanHide),
                new XAttribute("Detail", string.IsNullOrEmpty(info.Detail) ? "" : info.Detail),
                new XAttribute("EndDate", info.EndDate.ToString("yyyy-MM-dd HH:mm:ss")),
                new XAttribute("IsActive", info.IsActive),
                new XAttribute("IsOther", info.IsOther),
                new XAttribute("IsShare", info.IsShare),
                new XAttribute("NeedMaxLevel", info.NeedMaxLevel),
                new XAttribute("NeedMinLevel", info.NeedMinLevel),
                new XAttribute("PicID", info.PicID),
                new XAttribute("PlaceID", info.PlaceID),
                new XAttribute("PreAchievementID", string.IsNullOrEmpty(info.PreAchievementID) ? "" : info.PreAchievementID),
                new XAttribute("StartDate", info.StartDate.ToString("yyyy-MM-dd HH:mm:ss")),
                new XAttribute("Title", string.IsNullOrEmpty(info.Title) ? "" : info.Title));
        }

        public static XElement CreateAchievementCondition(AchievementConditionInfo info)
        {
            return new XElement("Item_Condiction",
                new XAttribute("AchievementID", info.AchievementID),
                new XAttribute("CondictionID", info.CondictionID),
                new XAttribute("CondictionType", info.CondictionType),
                new XAttribute("Condiction_Para1", string.IsNullOrEmpty(info.Condiction_Para1) ? "" : info.Condiction_Para1),
                new XAttribute("Condiction_Para2", info.Condiction_Para2));
        }

        public static XElement CreateAchievementReward(AchievementRewardInfo info)
        {
            return new XElement("Item_Reward",
                new XAttribute("AchievementID", info.AchievementID),
                new XAttribute("RewardValueId", info.RewardValueId),
                new XAttribute("RewardCount", info.RewardCount),
                new XAttribute("RewardType", info.RewardType),
                new XAttribute("RewardPara", string.IsNullOrEmpty(info.RewardPara) ? "" : info.RewardPara));
        }

        public static XElement CreateTotemHonorTemplate(TotemHonorTemplateInfo info)
        {
            return new XElement("item",
                new XAttribute("ID", info.ID),
                new XAttribute("Type", info.Type),
                new XAttribute("NeedMoney", info.NeedMoney),
                new XAttribute("AddHonor", info.AddHonor));
        }

        public static XElement CreatePetFightProterpy(PetFightPropertyInfo info)
        {
            return new XElement("Item", new XAttribute("ID", info.ID), new XAttribute("Exp", info.Exp), new XAttribute("Attack", info.Attack), new XAttribute("Agility", info.Agility), new XAttribute("Defence", info.Defence), new XAttribute("Lucky", info.Lucky), new XAttribute("Blood", info.Blood));
        }

        public static XElement CreateStrengThenExpItems(StrengThenExpInfo info)
        {
            return new XElement("Item",
            new XAttribute("Level", info.Level),
            new XAttribute("Exp", info.Exp),
            new XAttribute("NecklaceStrengthExp", info.NecklaceStrengthExp),
            new XAttribute("NecklaceStrengthPlus", info.NecklaceStrengthPlus));
        }

        public static XElement CreateFairBattleReward(FairBattleRewardInfo info)
        {
            return new XElement("item",
            new XAttribute("Score", info.Prestige),
            new XAttribute("Name", info.Name),
            new XAttribute("Level", info.Level));
        }

        public static XElement CreateDailyLeagueAward(DailyLeagueAwardInfo info)
        {
            return new XElement("item",
            new XAttribute("Level", info.Level),
            new XAttribute("Class", info.Class),
            new XAttribute("Count", info.Count),
            new XAttribute("TemplateID", info.TemplateID),
            new XAttribute("RewardID", info.RewardID),
            new XAttribute("StrengthenLevel", info.StrengthenLevel),
            new XAttribute("ItemValid", info.ItemValid),
            new XAttribute("IsBind", info.IsBind),
            new XAttribute("AgilityCompose", info.AgilityCompose),
            new XAttribute("AttackCompose", info.AttackCompose),
            new XAttribute("DefendCompose", info.DefendCompose),
            new XAttribute("LuckCompose", info.LuckCompose),
            new XAttribute("Hole1", info.Hole1),
            new XAttribute("Hole2", info.Hole2),
            new XAttribute("Hole3", info.Hole3),
            new XAttribute("Hole4", info.Hole4),
            new XAttribute("Hole5", info.Hole5),
            new XAttribute("Hole5Exp", info.Hole5Exp),
            new XAttribute("Hole5Level", info.Hole5Level),
            new XAttribute("Hole6", info.Hole6),
            new XAttribute("Hole6Exp", info.Hole6Exp),
            new XAttribute("Hole6Level", info.Hole6Level)
            );
        }
    }
}