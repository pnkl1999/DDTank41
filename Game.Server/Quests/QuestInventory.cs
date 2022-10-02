using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Buffer;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class QuestInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected ArrayList m_clearList;

        private UnicodeEncoding unicodeEncoding_0 = new UnicodeEncoding();

        private int m_changeCount;

        protected List<BaseQuest> m_changedQuests = new List<BaseQuest>();

        protected List<QuestDataInfo> m_datas;

        protected List<BaseQuest> m_list;

        private object m_lock;

        private GamePlayer m_player;

        private byte[] m_states;
        public QuestInventory(GamePlayer player)
        {
            this.m_player = player;
            this.m_lock = new object();
            this.m_list = new List<BaseQuest>();
            this.m_clearList = new ArrayList();
            this.m_datas = new List<QuestDataInfo>();
        }

        private bool AddQuest(BaseQuest quest)
        {
            List<BaseQuest> list = this.m_list;
            lock (list)
            {
                this.m_list.Add(quest);
            }
            quest.CheckRepeat();
            this.OnQuestsChanged(quest);
            quest.AddToPlayer(this.m_player);
            return true;
        }

        public bool AddQuest(QuestInfo info, out string msg)
        {
            msg = "";
            try
            {
                if (info == null)
                {
                    msg = "Game.Server.Quests.NoQuest";
                    return false;
                }
                if (info.TimeMode && DateTime.Now.CompareTo(info.StartDate) < 0)
                {
                    msg = "Game.Server.Quests.NoTime";
                }
                if (info.TimeMode && DateTime.Now.CompareTo(info.EndDate) > 0)
                {
                    msg = "Game.Server.Quests.TimeOver";
                }
                if (this.m_player.PlayerCharacter.Grade < info.NeedMinLevel)
                {
                    msg = "Game.Server.Quests.LevelLow";
                }
                if (this.m_player.PlayerCharacter.Grade > info.NeedMaxLevel)
                {
                    msg = "Game.Server.Quests.LevelTop";
                }
                if (info.PreQuestID != "0,")
                {
                    string[] array = info.PreQuestID.Split(new char[]
                    {
                        ','
                    });
                    for (int i = 0; i < array.Length - 1; i++)
                    {
                        if (!this.IsQuestFinish(Convert.ToInt32(array[i])))
                        {
                            msg = "Game.Server.Quests.NoFinish";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                QuestInventory.log.Info(ex.InnerException);
            }
            if (info.IsOther == 1 && !this.m_player.PlayerCharacter.IsConsortia)
            {
                msg = "Game.Server.Quest.QuestInventory.HaveMarry";
            }
            if (info.IsOther == 2 && !this.m_player.PlayerCharacter.IsMarried)
            {
                msg = "Game.Server.Quest.QuestInventory.HaveMarry";
            }
            BaseQuest baseQuest = this.FindQuest(info.ID);
            if (baseQuest != null && baseQuest.Data.IsComplete)
            {
                msg = "Game.Server.Quests.Have";
            }
            if (baseQuest != null && !baseQuest.Info.CanRepeat)
            {
                msg = "Game.Server.Quests.NoRepeat";
            }
            if (baseQuest != null && DateTime.Now.CompareTo(baseQuest.Data.CompletedDate.Date.AddDays((double)baseQuest.Info.RepeatInterval)) < 0 && baseQuest.Data.RepeatFinish < 1)
            {
                msg = "Game.Server.Quests.Rest";
            }
            if (this.m_player.QuestInventory.FindQuest(info.ID) != null)
            {
                msg = "Game.Server.Quests.Have";
            }
            bool result;
            if (!(msg == ""))
            {
                msg = LanguageMgr.GetTranslation(msg, Array.Empty<object>());
                result = false;
            }
            else
            {
                QuestMgr.GetQuestCondiction(info);
                int rand = 1;
                if (ThreadSafeRandom.NextStatic(1000000) <= info.Rands)
                {
                    rand = info.RandDouble;
                }
                this.BeginChanges();
                if (baseQuest != null)
                {
                    baseQuest.Reset(this.m_player, rand);
                    baseQuest.AddToPlayer(this.m_player);
                    this.OnQuestsChanged(baseQuest);
                }
                else
                {
                    baseQuest = new BaseQuest(info, new QuestDataInfo());
                    this.AddQuest(baseQuest);
                    baseQuest.Reset(this.m_player, rand);
                }
                this.CommitChanges();
                result = true;
            }
            return result;
        }

        private bool method_1(QuestDataInfo questDataInfo_0)
        {
            List<BaseQuest> list = this.m_list;
            lock (list)
            {
                this.m_datas.Add(questDataInfo_0);
            }
            return true;
        }

        private void BeginChanges()
        {
            Interlocked.Increment(ref this.m_changeCount);
        }

        public bool ClearConsortiaQuest()
        {
            return true;
        }

        public bool ClearMarryQuest()
        {
            return true;
        }

        private void CommitChanges()
        {
            int num = Interlocked.Decrement(ref this.m_changeCount);
            if (num < 0)
            {
                if (QuestInventory.log.IsErrorEnabled)
                {
                    QuestInventory.log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
                }
                Thread.VolatileWrite(ref this.m_changeCount, 0);
            }
            if (num <= 0 && this.m_changedQuests.Count > 0)
            {
                this.UpdateChangedQuests();
            }
        }

        public bool FindFinishQuestData(int ID, int UserID)
        {
            bool flag = false;
            List<QuestDataInfo> datas = this.m_datas;
            bool result;
            lock (datas)
            {
                foreach (QuestDataInfo questDataInfo in this.m_datas)
                {
                    if (questDataInfo.QuestID == ID && questDataInfo.UserID == UserID)
                    {
                        flag = questDataInfo.IsComplete;
                    }
                }
                result = flag;
            }
            return result;
        }

        public BaseQuest FindQuest(int id)
        {
            foreach (BaseQuest baseQuest in this.m_list)
            {
                if (baseQuest.Info.ID == id)
                {
                    return baseQuest;
                }
            }
            return null;
        }

        public bool Finish(BaseQuest baseQuest, int selectedItem)
        {
            string msg = "";
            QuestInfo qinfo = baseQuest.Info;
            QuestDataInfo data = baseQuest.Data;
            this.m_player.BeginAllChanges();
            try
            {
                bool checkbag = true;
                if (m_player.EquipBag.FindFirstEmptySlot() < 0)
                    checkbag = false;
                if (m_player.PropBag.FindFirstEmptySlot() < 0)
                    checkbag = false;
                if (m_player.FarmBag.FindFirstEmptySlot() < 0)
                    checkbag = false;
                if (checkbag)
                {
                    if (baseQuest.Finish(this.m_player))
                    {
                        List<QuestAwardInfo> awards = QuestMgr.GetQuestGoods(qinfo);
                        List<ItemInfo> mainBg = new List<ItemInfo>();
                        List<ItemInfo> propBg = new List<ItemInfo>();
                        List<ItemInfo> farmBg = new List<ItemInfo>();
                        List<ItemInfo> overdueItems = new List<ItemInfo>();
                        foreach (QuestAwardInfo award in awards)
                        {
                            if (!award.IsSelect || award.RewardItemID == selectedItem)
                            {
                                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(award.RewardItemID);
                                if (temp != null)
                                {
                                    msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardProp", new object[]
                                    {
                                    temp.Name,
                                    award.RewardItemCount
                                    }) + " ";
                                    int Sex = this.m_player.PlayerCharacter.Sex ? 1 : 2;
                                    if (temp.NeedSex == 0 || temp.NeedSex == Sex)
                                    {
                                        int tempCount = award.RewardItemCount;
                                        if (award.IsCount)
                                        {
                                            tempCount *= data.RandDobule;
                                        }
                                        for (int len = 0; len < tempCount; len += temp.MaxCount)
                                        {
                                            int num3 = (len + temp.MaxCount > award.RewardItemCount) ? (award.RewardItemCount - len) : temp.MaxCount;
                                            ItemInfo itemInfo = ItemInfo.CreateFromTemplate(temp, num3, 106);
                                            if (itemInfo != null)
                                            {
                                                itemInfo.ValidDate = award.RewardItemValid;
                                                itemInfo.IsBinds = true;
                                                itemInfo.StrengthenLevel = award.StrengthenLevel;
                                                itemInfo.AttackCompose = award.AttackCompose;
                                                itemInfo.DefendCompose = award.DefendCompose;
                                                itemInfo.AgilityCompose = award.AgilityCompose;
                                                itemInfo.LuckCompose = award.LuckCompose;
                                                if (temp.BagType == eBageType.PropBag)
                                                {
                                                    propBg.Add(itemInfo);
                                                }
                                                else if (temp.BagType == eBageType.FarmBag)
                                                {
                                                    farmBg.Add(itemInfo);
                                                }
                                                else
                                                {
                                                    mainBg.Add(itemInfo);
                                                }
                                                if (temp.TemplateID == 11408)
                                                {
                                                    this.m_player.LoadMedals();
                                                    this.m_player.OnPlayerAddItem("Medal", num3);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (mainBg.Count > 0 && this.m_player.EquipBag.GetEmptyCount() < mainBg.Count)
                        {
                            baseQuest.CancelFinish(this.m_player);
                            this.m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, this.m_player.GetInventoryName(eBageType.EquipBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull", Array.Empty<object>()) + " ");
                            return false;
                        }
                        if (propBg.Count > 0 && this.m_player.PropBag.GetEmptyCount() < propBg.Count)
                        {
                            baseQuest.CancelFinish(this.m_player);
                            this.m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, this.m_player.GetInventoryName(eBageType.PropBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull", Array.Empty<object>()) + " ");
                            return false;
                        }
                        if (farmBg.Count > 0 && this.m_player.FarmBag.GetEmptyCount() < farmBg.Count)
                        {
                            baseQuest.CancelFinish(this.m_player);
                            this.m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, this.m_player.GetInventoryName(eBageType.FarmBag) + LanguageMgr.GetTranslation("Game.Server.Quests.BagFull", Array.Empty<object>()) + " ");
                            return false;
                        }
                        foreach (ItemInfo item in mainBg)
                        {
                            if (!this.m_player.EquipBag.StackItemToAnother(item) && !this.m_player.EquipBag.AddItem(item))
                            {
                                overdueItems.Add(item);
                            }
                        }
                        foreach (ItemInfo item in propBg)
                        {
                            if (item.TemplateID == 11408)
                            {
                                item.Count *= data.RandDobule;
                            }
                            if (item.Template.CategoryID != 10)
                            {
                                if (!m_player.PropBag.StackItemToAnother(item) && !m_player.PropBag.AddItem(item))
                                {
                                    overdueItems.Add(item);
                                }
                                continue;
                            }
                            switch (item.TemplateID)
                            {
                                case 10001:
                                    m_player.PlayerCharacter.openFunction(Step.PICK_TWO_TWENTY);
                                    break;
                                case 10003:
                                    m_player.PlayerCharacter.openFunction(Step.POP_WIN);
                                    break;
                                case 10004:
                                    m_player.PlayerCharacter.openFunction(Step.FIFTY_OPEN);
                                    m_player.AddGift(eGiftType.MONEY);
                                    m_player.AddGift(eGiftType.BIG_EXP);
                                    m_player.AddGift(eGiftType.PET_EXP);
                                    break;
                                case 10005:
                                    m_player.PlayerCharacter.openFunction(Step.FORTY_OPEN);
                                    break;
                                case 10006:
                                    m_player.PlayerCharacter.openFunction(Step.THIRTY_OPEN);
                                    break;
                                case 10007:
                                    m_player.PlayerCharacter.openFunction(Step.POP_TWO_TWENTY);
                                    m_player.AddGift(eGiftType.SMALL_EXP);
                                    break;
                                case 10008:
                                    m_player.PlayerCharacter.openFunction(Step.GAIN_TEN_PERSENT);
                                    break;
                                case 10024:
                                    m_player.PlayerCharacter.openFunction(Step.PICK_ONE);
                                    break;
                                case 10025:
                                    m_player.PlayerCharacter.openFunction(Step.PLANE_OPEN);
                                    break;
                            }
                        }
                        foreach (ItemInfo item in farmBg)
                        {
                            if (!m_player.EquipBag.AddItem(item))
                            {
                                overdueItems.Add(item);
                            }
                        }
                        if (overdueItems.Count > 0)
                        {
                            this.m_player.SendItemsToMail(overdueItems, "Túi đầy", "Vật phẩm được gửi từ hệ thống", eMailType.ItemOverdue);
                            this.m_player.Out.SendMailResponse(this.m_player.PlayerCharacter.ID, eMailRespose.Receiver);
                        }
                        msg = LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.Reward", Array.Empty<object>()) + msg;
                        if (qinfo.RewardBuffID > 0 && qinfo.RewardBuffDate > 0)
                        {
                            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(qinfo.RewardBuffID);
                            if (temp != null)
                            {
                                int RewardBuffDate = qinfo.RewardBuffDate * data.RandDobule;
                                BufferList.CreateBufferHour(temp, RewardBuffDate).Start(this.m_player);
                                msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardBuff", temp.Name, RewardBuffDate) + " ";
                            }
                        }
                        if (qinfo.RewardGold != 0)
                        {
                            int RewardGold = qinfo.RewardGold * data.RandDobule;
                            this.m_player.AddGold(RewardGold);
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGold", RewardGold) + " ";
                        }
                        if (qinfo.RewardMoney != 0)
                        {
                            int RewardMoney = qinfo.RewardMoney * data.RandDobule;
                            this.m_player.AddMoney(qinfo.RewardMoney * data.RandDobule);
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardMoney", RewardMoney) + " ";
                        }
                        if (qinfo.RewardGP != 0)
                        {
                            int RewardGP = qinfo.RewardGP * data.RandDobule;
                            this.m_player.AddGP(RewardGP/*,"GP74232"*/);
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGB1", RewardGP) + " ";
                        }
                        if (qinfo.RewardRiches != 0 && this.m_player.PlayerCharacter.ConsortiaID != 0)
                        {
                            int RewardRiches = qinfo.RewardRiches * data.RandDobule;
                            this.m_player.AddRichesOffer(RewardRiches);
                            using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
                            {
                                consortiaBussiness.ConsortiaRichAdd(this.m_player.PlayerCharacter.ConsortiaID, ref RewardRiches);
                            }
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardRiches", RewardRiches) + " ";
                        }
                        if (qinfo.RewardOffer != 0)
                        {
                            int RewardOffer = qinfo.RewardOffer * data.RandDobule;
                            this.m_player.AddOffer(RewardOffer, false);
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardOffer", RewardOffer) + " ";
                        }
                        if (qinfo.RewardGiftToken != 0)
                        {
                            int RewardGiftToken = qinfo.RewardGiftToken * data.RandDobule;
                            this.m_player.AddGiftToken(RewardGiftToken);
                            msg = msg + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardGiftToken", RewardGiftToken + " ");
                        }
                        this.m_player.Out.SendMessage(eMessageType.GM_NOTICE, msg);
                        this.RemoveQuest(baseQuest);
                        this.SetQuestFinish(baseQuest.Info.ID);
                        this.m_player.PlayerCharacter.QuestSite = this.m_states;
                        this.SaveToDatabase();
                    }
                }
                else
                {
                    m_player.SendMessage("Bạn cần dọn túi trước khi hoàn thành nhiệm vụ.");
                }
                this.OnQuestsChanged(baseQuest);
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                    log.Error("Quest Finish：" + ex);
                return false;
            }
            finally
            {
                this.m_player.CommitAllChanges();
            }
            return true;
        }

        private byte[] method_4()
        {
            byte[] array = new byte[200];
            for (int i = 0; i < 200; i++)
            {
                array[i] = 0;
            }
            return array;
        }

        private bool IsQuestFinish(int int_1)
        {
            bool result;
            if (int_1 > this.m_states.Length * 8 || int_1 < 1)
            {
                result = false;
            }
            else
            {
                int_1--;
                int num = int_1 / 8;
                int num2 = int_1 % 8;
                result = (((int)this.m_states[num] & 1 << num2) != 0);
            }
            return result;
        }
        public void LoadFromDatabase(int playerId)
        {
            object obj = this.m_lock;
            lock (obj)
            {
                this.m_states = ((this.m_player.PlayerCharacter.QuestSite.Length == 0) ? this.method_4() : this.m_player.PlayerCharacter.QuestSite);
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    QuestDataInfo[] userQuest = playerBussiness.GetUserQuest(playerId);
                    this.BeginChanges();
                    QuestDataInfo[] array = userQuest;
                    foreach (QuestDataInfo questDataInfo in array)
                    {
                        QuestInfo singleQuest = QuestMgr.GetSingleQuest(questDataInfo.QuestID);
                        if (singleQuest != null)
                        {
                            this.AddQuest(new BaseQuest(singleQuest, questDataInfo));
                        }
                        this.method_1(questDataInfo);
                    }
                    this.CommitChanges();
                }
            }
        }

        public List<QuestDataInfo> GetAllQuestData()
        {
            return this.m_datas;
        }

        protected void OnQuestsChanged(BaseQuest quest)
        {
            if (!this.m_changedQuests.Contains(quest))
            {
                this.m_changedQuests.Add(quest);
            }
            if (this.m_changeCount <= 0 && this.m_changedQuests.Count > 0)
            {
                this.UpdateChangedQuests();
            }
        }

        public bool RemoveQuest(BaseQuest quest)
        {
            int rand = 1;
            bool result;
            if (!quest.Info.CanRepeat)
            {
                bool flag = false;
                List<BaseQuest> list = this.m_list;
                lock (list)
                {
                    if (this.m_list.Remove(quest))
                    {
                        this.m_clearList.Add(quest);
                        flag = true;
                    }
                }
                if (flag)
                {
                    quest.RemoveFromPlayer(this.m_player);
                    this.OnQuestsChanged(quest);
                }
                result = flag;
            }
            else
            {
                if (ThreadSafeRandom.NextStatic(1000000) <= quest.Info.Rands)
                {
                    rand = quest.Info.RandDouble;
                }
                quest.Reset(this.m_player, rand);
                QuestDataInfo data = quest.Data;
                QuestDataInfo questDataInfo = data;
                int repeatFinish = questDataInfo.RepeatFinish;
                questDataInfo.RepeatFinish = repeatFinish - 1;
                if (data.RepeatFinish <= 0)
                {
                    data.IsComplete = true;
                }
                quest.SaveData();
                this.OnQuestsChanged(quest);
                result = true;
            }
            return result;
        }

        public void SaveToDatabase()
        {
            lock (this.m_lock)
            {
                using (PlayerBussiness playerBussiness = new PlayerBussiness())
                {
                    foreach (BaseQuest baseQuest in this.m_list)
                    {
                        baseQuest.SaveData();
                        if (baseQuest.Data.IsDirty)
                            playerBussiness.UpdateDbQuestDataInfo(baseQuest.Data);
                    }
                    foreach (BaseQuest clear in this.m_clearList)
                    {
                        clear.SaveData();
                        playerBussiness.UpdateDbQuestDataInfo(clear.Data);
                    }
                    this.m_clearList.Clear();
                }
            }
        }

        private bool SetQuestFinish(int questId)
        {
            bool result;
            if (questId > this.m_states.Length * 8 || questId < 1)
            {
                result = false;
            }
            else
            {
                questId--;
                int num = questId / 8;
                int num2 = questId % 8;
                this.m_states[num] = (byte)((int)this.m_states[num] | 1 << num2);
                result = true;
            }
            return result;
        }

        public void Update(BaseQuest quest)
        {
            this.OnQuestsChanged(quest);
        }

        public void UpdateChangedQuests()
        {
            this.m_player.Out.SendUpdateQuests(this.m_player, this.m_states, this.m_changedQuests.ToArray());
            this.m_changedQuests.Clear();
        }

        public bool Restart()
        {
            bool result = false;
            foreach (QuestDataInfo questDataInfo in this.GetAllQuestData())
            {
                BaseQuest baseQuest = this.FindQuest(questDataInfo.QuestID);
                if (baseQuest != null && baseQuest.Info.CanRepeat && baseQuest.Data.IsComplete)
                {
                    List<QuestConditionInfo> questCondiction = QuestMgr.GetQuestCondiction(baseQuest.Info);
                    if (questCondiction.Count > 0)
                    {
                        baseQuest.Data.Condition1 = questCondiction[0].Para2;
                    }
                    if (questCondiction.Count > 1)
                    {
                        baseQuest.Data.Condition2 = questCondiction[1].Para2;
                    }
                    if (questCondiction.Count > 2)
                    {
                        baseQuest.Data.Condition3 = questCondiction[2].Para2;
                    }
                    if (questCondiction.Count > 3)
                    {
                        baseQuest.Data.Condition4 = questCondiction[3].Para2;
                    }
                    --baseQuest.Data.RepeatFinish;
                    baseQuest.Data.IsComplete = false;
                    baseQuest.Reset(this.m_player);
                    baseQuest.Update();
                    this.SaveToDatabase();
                    result = true;
                }
            }
            return result;
        }
    }
}
