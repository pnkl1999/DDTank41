using Bussiness;
using Bussiness.Managers;
using Game.Logic;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.GameUtils
{
    public class PlayerEquipInventory : PlayerInventory
    {
        public static readonly ILog log = LogManager.GetLogger("ItemLogger");

        private static readonly int[] StyleIndex = new int[15]
        {
            1,
            2,
            3,
            4,
            5,
            6,
            11,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20
        };

        public PlayerEquipInventory(GamePlayer player)
            : base(player, saveTodb: true, 127, (int)eBageType.EquipBag, 31, autoStack: true)
        {
        }

        //public override void LoadFromDatabase()
        //{
        //    List<ItemInfo> overdueItems = new List<ItemInfo>();
        //    int EQUIPBAG_START = 31;
        //    int EQUIPBAG_END = 127;
        //    BeginChanges();
        //    try
        //    {
        //        base.LoadFromDatabase();
        //        for (int i = 0; i < EQUIPBAG_START; i++)
        //        {
        //            ItemInfo item = m_items[i];

        //            if (item == null)
        //                continue;

        //            if (item.Template == null)
        //            {
        //                TakeOutItem(item);
        //                continue;
        //            }

        //            if (item.IsEquipPet() && item.Place < EQUIPBAG_START)
        //            {
        //                ItemInfo toItem = item.Clone();
        //                overdueItems.Add(toItem);
        //                TakeOutItem(item);
        //                continue;
        //            }

        //            if (!CanEquipSlotContains(item.Place, item.Template))
        //            {
        //                ItemInfo toItem = item.Clone();
        //                overdueItems.Add(toItem);
        //                TakeOutItem(item);
        //                continue;
        //            }

        //            if (!item.IsValidItem())
        //            {
        //                int slot = -1;
        //                slot = FindFirstEmptySlot(EQUIPBAG_START, EQUIPBAG_END);
        //                if (slot >= 0)
        //                {
        //                    MoveItem(item.Place, slot, item.Count);
        //                }
        //                else
        //                {
        //                    overdueItems.Add(item);
        //                    TakeOutItem(item);
        //                }
        //            }
        //        }
        //    }
        //    finally
        //    {
        //        if (overdueItems.Count > 0)
        //        {
        //            m_player.SendItemsToMail(overdueItems, LanguageMgr.GetTranslation("ItemOverdueHandler.Content"), LanguageMgr.GetTranslation("ItemOverdueHandler.Title"), eMailType.ItemOverdue);
        //            m_player.Out.SendMailResponse(m_player.PlayerCharacter.ID, eMailRespose.Receiver);
        //        }
        //        CommitChanges();
        //    }
        //}

        public override void LoadFromDatabase()
        {
            BeginChanges();
            try
            {
                base.LoadFromDatabase();
            }
            finally
            {
                CommitChanges();
            }
        }

        public override bool MoveItem(int fromSlot, int toSlot, int count)
        {
            if (fromSlot < 0 || toSlot < 0 || fromSlot >= m_items.Length || toSlot >= m_items.Length || m_items[fromSlot] == null)
            {
                return false;
            }
            if (IsEquipSlot(fromSlot) && !IsEquipSlot(toSlot) && m_items[toSlot] != null && m_items[toSlot].Template.CategoryID != m_items[fromSlot].Template.CategoryID)
            {
                if (!CanEquipSlotContains(fromSlot, m_items[toSlot].Template))
                {
                    toSlot = FindFirstEmptySlot(31);
                }
            }
            else
            {
                if (IsEquipSlot(toSlot))
                {
                    if (!CanEquipSlotContains(toSlot, m_items[fromSlot].Template))
                    {
                        UpdateItem(m_items[fromSlot]);
                        return false;
                    }
                    if (!m_player.CanEquip(m_items[fromSlot].Template) || !m_items[fromSlot].IsValidItem())
                    {
                        UpdateItem(m_items[fromSlot]);
                        return false;
                    }
                    if (m_items[fromSlot] != null)
                    {
                        m_player.OnNewGearEvent(m_items[fromSlot]);
                    }
                }
                if (IsEquipSlot(fromSlot))
                {
                    if (m_items[toSlot] != null && !CanEquipSlotContains(fromSlot, m_items[toSlot].Template))
                    {
                        UpdateItem(m_items[toSlot]);
                        return false;
                    }
                    if (m_items[toSlot] != null)
                    {
                        m_player.OnNewGearEvent(m_items[toSlot]);
                    }
                }
            }
            return base.MoveItem(fromSlot, toSlot, count);
        }

        public override void UpdateChangedPlaces()
        {
            int[] changedSlot = m_changedPlaces.ToArray();
            bool updateStyle = false;
            //int[] array2 = array;
            //int[] array3 = array2;
            foreach (int slot in changedSlot)
            {
                if (!IsEquipSlot(slot))
                {
                    continue;
                }
                ItemInfo item = GetItemAt(slot);
                if (item != null)
                {
                    m_player.OnUsingItem(item.TemplateID, 1);
                    item.IsBinds = true;
                    if (!item.IsUsed)
                    {
                        item.IsUsed = true;
                        item.BeginDate = DateTime.Now;
                    }
                }
                updateStyle = true;
                break;
            }
            base.UpdateChangedPlaces();
            if (updateStyle)
            {
                UpdatePlayerProperties();
            }
        }

        public void UpdatePlayerProperties()
        {
            m_player.BeginChanges();
            try
            {
                int attack = 0;
                int defence = 0;
                int agility = 0;
                int lucky = 0;
                int hp = 0;
                int strengthenLevel = 0;
                string style = "";
                string color = "";
                string skin = "";
                int texpattack = 0;
                int texpdefence = 0;
                int texpagility = 0;
                int texplucky = 0;
                int texphp = 0;
                int gematt = 0;
                int gemdef = 0;
                int gemagi = 0;
                int gemluck = 0;
                int gemhp = 0;
                int cardattack = 0;
                int carddefence = 0;
                int cardagility = 0;
                int cardlucky = 0;
                int petattack = 0;
                int petdefence = 0;
                int petagility = 0;
                int petlucky = 0;
                int pethp = 0;
                int petMoeAtt = 0;
                int petMoeDef = 0;
                int petMoeAgi = 0;
                int petMoeLucky = 0;
                int petMoeHP = 0;
                int petMoeGuard = 0;
                int clothAttack = 0;
                int clothDefend = 0;
                int clothAgility = 0;
                int clothLuck = 0;
                int clothBlood = 0;
                List<UsersCardInfo> infos;
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    infos = pb.GetUserCardEuqip(m_player.PlayerCharacter.ID);
                }
                m_player.UpdatePet(m_player.PetBag.GetPetIsEquip());
                lock (m_lock)
                {
                    //style = ((m_items[0] == null) ? "" : m_items[0].TemplateID.ToString());
                    //color = ((m_items[0] == null) ? "" : m_items[0].Color);
                    //skin = ((m_items[5] == null) ? "" : m_items[5].Skin);
                    style = m_items[0] == null ? "" : m_items[0].TemplateID.ToString() + "|" + m_items[0].Pic;
                    color = m_items[0] == null ? "" : m_items[0].Color;
                    skin = m_items[5] == null ? "" : m_items[5].Skin;
                    for (int i = 0; i < 31; i++)
                    {
                        ItemInfo item = m_items[i];
                        if (item == null)
                        {
                            continue;
                        }
                        attack += item.Attack;
                        defence += item.Defence;
                        agility += item.Agility;
                        lucky += item.Luck;
                        strengthenLevel = strengthenLevel > item.StrengthenLevel ? strengthenLevel : item.StrengthenLevel;
                        AddBaseLatentProperty(item, ref attack, ref defence, ref agility, ref lucky);
                        AddBaseGemstoneProperty(item, ref gematt, ref gemdef, ref gemagi, ref gemluck, ref gemhp);
                        if (item.isGold)
                        {
                            GoldEquipTemplateInfo GoldEquip = GoldEquipMgr.FindGoldEquipByTemplate(item.Template.TemplateID, item.Template.CategoryID);
                            if (GoldEquip != null)
                            {
                                attack += GoldEquip.Attack > 0 ? GoldEquip.Attack : 0;
                                defence += GoldEquip.Defence > 0 ? GoldEquip.Defence : 0;
                                agility += GoldEquip.Agility > 0 ? GoldEquip.Agility : 0;
                                lucky += GoldEquip.Luck > 0 ? GoldEquip.Luck : 0;
                                hp += GoldEquip.Boold > 0 ? GoldEquip.Boold : 0;
                            }
                        }
                        AddProperty(item, ref attack, ref defence, ref agility, ref lucky);
                    }
                    EquipBuffer();
                    for (int i = 0; i < StyleIndex.Length; i++)
                    {
                        style += ",";
                        color += ",";
                        if (m_items[StyleIndex[i]] != null)
                        {
                            //style += m_items[StyleIndex[i]].TemplateID;
                            //color += m_items[StyleIndex[i]].Color;
                            style += m_items[StyleIndex[i]].TemplateID + "|" + m_items[StyleIndex[i]].Pic;
                            color += m_items[StyleIndex[i]].Color;
                        }
                    }
                    texpattack += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.attTexpExp, "A");
                    texpdefence += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.defTexpExp, "D");
                    texpagility += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.spdTexpExp, "AG");
                    texplucky += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.lukTexpExp, "L");
                    texphp += ExerciseMgr.GetExercise(m_player.PlayerCharacter.Texp.hpTexpExp, "H");
                    base.Player.CardBuff.Clear();
                    int MaxLevel = 30;
                    foreach (UsersCardInfo cardSlots in m_player.CardBag.GetCards(0, 4))
                    {
                        ItemTemplateInfo Card = ItemMgr.FindItemTemplate(cardSlots.TemplateID);
                        if (Card == null)
                        {
                            continue;
                        }
                        cardattack += Card.Attack + cardSlots.TotalAttack;
                        carddefence += Card.Defence + cardSlots.TotalDefence;
                        cardagility += Card.Agility + cardSlots.TotalAgility;
                        cardlucky += Card.Luck + cardSlots.TotalLuck;
                        for (int i = 1; i <= cardSlots.Level; i++)
                        {
                            CardUpdateInfo CardUpdate = CardMgr.GetCardUpdateInfo(cardSlots.TemplateID, i);
                            if (CardUpdate != null)
                            {
                                attack += CardUpdate.Attack;
                                defence += CardUpdate.Defend;
                                agility += CardUpdate.Agility;
                                lucky += CardUpdate.Lucky;
                            }
                        }
                        if (cardSlots.Level < MaxLevel)
                        {
                            MaxLevel = cardSlots.Level;
                        }
                        if (cardSlots.CardID != 0)
                        {
                            base.Player.CardBuff.Add(cardSlots.TemplateID);
                        }
                        m_player.OnEquipCardEvent();
                    }
                    if (base.Player.CardBuff.Count >= 2)
                    {
                        base.Player.CardBuff.Add(MaxLevel + 1000);
                    }

                    m_player.Rank.AddBaseRankProperty(ref attack, ref defence, ref agility, ref lucky);

                    if (m_player.Pet != null)
                    {
                        petattack += m_player.Pet.TotalAttack;
                        petdefence += m_player.Pet.TotalDefence;
                        petagility += m_player.Pet.TotalAgility;
                        petlucky += m_player.Pet.TotalLuck;
                        pethp += m_player.Pet.TotalBlood;
                        PetFightPropertyInfo PetFightPro = PetMgr.FindFightProperty(m_player.PlayerCharacter.evolutionGrade);
                        if (PetFightPro != null)
                        {
                            petattack += PetFightPro.Attack;
                            petdefence += PetFightPro.Defence;
                            petagility += PetFightPro.Agility;
                            petlucky += PetFightPro.Lucky;
                            pethp += PetFightPro.Blood;
                        }
                        EatPetsInfo eatPets = m_player.PetBag.EatPets;
                        foreach (PetEquipInfo petEquip in m_player.Pet.PetEquips)
                        {
                            if (eatPets == null)
                            {
                                continue;
                            }
                            if (petEquip.eqType == 0)
                            {
                                PetMoePropertyInfo petMoePropertyInfo = PetMoePropertyMgr.FindPetMoeProperty(eatPets.weaponLevel);
                                if (petMoePropertyInfo != null)
                                {
                                    petMoeAtt += petMoePropertyInfo.Attack;
                                    petMoeLucky += petMoePropertyInfo.Lucky;
                                }
                            }
                            else if (petEquip.eqType == 1)
                            {
                                PetMoePropertyInfo petMoePropertyInfo2 = PetMoePropertyMgr.FindPetMoeProperty(eatPets.hatLevel);
                                if (petMoePropertyInfo2 != null)
                                {
                                    petMoeDef += petMoePropertyInfo2.Defence;
                                    petMoeGuard += petMoePropertyInfo2.Guard;
                                }
                            }
                            else if (petEquip.eqType == 2)
                            {
                                PetMoePropertyInfo petMoePropertyInfo3 = PetMoePropertyMgr.FindPetMoeProperty(eatPets.clothesLevel);
                                if (petMoePropertyInfo3 != null)
                                {
                                    petMoeAgi += petMoePropertyInfo3.Agility;
                                    petMoeHP += petMoePropertyInfo3.Blood;
                                }
                            }
                        }
                    }
                    int[] array = PropertySuit();
                    //texpattack += array[0];
                    //texpdefence += array[1];
                    //texpagility += array[2];
                    //texplucky += array[3];
                    //texphp += array[4];
                    attack += array[0];
                    defence += array[1];
                    agility += array[2];
                    lucky += array[3];
                    hp += array[4];

                    List<UserAvatarCollectionInfo> avatarPropertyActived = this.m_player.AvatarCollect.GetAvatarPropertyActived();
                    if (avatarPropertyActived.Count > 0)
                    {
                        foreach (UserAvatarCollectionInfo current2 in avatarPropertyActived)
                        {
                            if (current2.IsAvailable())
                            {
                                ClothPropertyTemplateInfo clothProperty = current2.ClothProperty;
                                if (clothProperty != null)
                                {
                                    int num84 = ClothGroupTemplateInfoMgr.CountClothGroupWithID(current2.AvatarID);
                                    if (current2.Items.Count >= num84 / 2 && current2.Items.Count < num84)
                                    {
                                        clothAttack += clothProperty.Attack;
                                        clothAgility += clothProperty.Agility;
                                        clothDefend += clothProperty.Defend;
                                        clothLuck += clothProperty.Luck;
                                        clothBlood += clothProperty.Blood;
                                    }
                                    else if (current2.Items.Count == num84)
                                    {
                                        clothAttack += clothProperty.Attack * 2;
                                        clothAgility += clothProperty.Agility * 2;
                                        clothDefend += clothProperty.Defend * 2;
                                        clothLuck += clothProperty.Luck * 2;
                                        clothBlood += clothProperty.Blood * 2;
                                    }
                                }
                            }
                        }
                    }
                    AddBaseTotemProperty(m_player.PlayerCharacter.totemId, ref attack, ref defence, ref agility, ref lucky, ref hp);
                }
                attack += texpattack + gematt + cardattack + petattack + petMoeAtt + clothAttack;
                defence += texpdefence + gemdef + carddefence + petdefence + petMoeDef + clothDefend;
                agility += texpagility + gemagi + cardagility + petagility + petMoeAgi + clothAgility;
                lucky += texplucky + gemluck + cardlucky + petlucky + petMoeLucky + clothLuck;
                hp += texphp + gemhp + pethp + petMoeHP + clothBlood;
                m_player.UpdateBaseProperties(attack, defence, agility, lucky, hp, petMoeGuard);
                m_player.UpdateStyle(style, color, skin);
                GetUserNimbus();
                m_player.ApertureEquip(strengthenLevel);
                m_player.UpdateWeapon(m_items[6]);
                m_player.UpdateSecondWeapon(m_items[15]);
                m_player.UpdateReduceDame(m_items[17]);
                m_player.UpdateHealstone(m_items[18]);
                m_player.PlayerProp.CreateProp(isSelf: true, "Texp", texpattack, texpdefence, texpagility, texplucky, texphp);
                m_player.PlayerProp.CreateProp(isSelf: true, "Gem", gematt, gemdef, gemagi, gemluck, gemhp);
                m_player.PlayerProp.CreateProp(true, "Avatar", clothAttack, clothDefend, clothAgility, clothLuck, clothBlood);
                m_player.UpdateFightPower();
                m_player.PlayerProp.ViewCurrent();
                m_player.OnPropertiesChange();
            }
            finally
            {
                m_player.CommitChanges();
            }
        }

        public int[] PropertySuit()//
        {
            int[] array = new int[5];
            using (ProduceBussiness pb = new ProduceBussiness())
            {
                try
                {
                    pb.Reset_Suit_Kill(base.Player.PlayerCharacter.ID);
                }
                catch
                {
                }
            }
            List<ItemInfo> DS = new List<ItemInfo>();
            for (int k = 0; k < 31; k++)
            {
                ItemInfo itemInfo = m_items[k];
                if (itemInfo != null && itemInfo.Template.SuitId > 0)
                {
                    DS.Add(itemInfo);
                }
            }
            List<ItemInfo> GetAllSuit = DS.FindAll((ItemInfo a) => DS.IndexOf(DS[DS.FindIndex((ItemInfo b) => b.Template.SuitId == a.Template.SuitId)]) < DS.LastIndexOf(DS[DS.FindLastIndex((ItemInfo c) => c.Template.SuitId == a.Template.SuitId)]) && (a.Template.NeedSex == 0 || DS.FindIndex((ItemInfo b) => b.Template.NeedSex == a.Template.NeedSex) != DS.FindLastIndex((ItemInfo c) => c.Template.NeedSex == a.Template.NeedSex)));
            List<List<ItemInfo>> list = new List<List<ItemInfo>>();
            List<List<ItemInfo>> ListC = new List<List<ItemInfo>>();
            List<int> list2 = new List<int>();
            List<int> list3 = new List<int>();
            if (GetAllSuit.Count > 1)
            {
                int j;
                for (j = 0; j < GetAllSuit.Count; j++)
                {
                    if (!list2.Contains(GetAllSuit[j].Template.SuitId))
                    {
                        list2.Add(GetAllSuit[j].Template.SuitId);
                        list3.Add(GetAllSuit[j].TemplateID);
                        list.Add(GetAllSuit.FindAll((ItemInfo a) => a.Template.SuitId == GetAllSuit[j].Template.SuitId));
                    }
                }
                if (list.Count > 0)
                {
                    ListC = list;
                    for (int l = 0; l < list.Count; l++)
                    {
                        if (list[l].Count < 1)
                        {
                            ListC.Remove(list[l]);
                        }
                    }
                }
            }
            if (ListC.Count > 0)
            {
                int i;
                for (i = 0; i < ListC.Count; i++)
                {
                    if (ListC[i].Count <= 1)
                    {
                        continue;
                    }
                    List<Suit_TemplateID> list4 = GamePlayer.Load_Suit_TemplateID().FindAll((Suit_TemplateID a) => a.ID == ListC[i][0].Template.SuitId);
                    int num = 0;
                    for (int m = 0; m < list4.Count; m++)
                    {
                        if (list4.Count <= 1)
                        {
                            break;
                        }
                        for (int n = 0; n < ListC[i].Count; n++)
                        {
                            if (tachchuoi(list4[m].ContainEquip).Contains(ListC[i][n].Template.TemplateID))
                            {
                                num++;
                            }
                        }
                    }
                    if (ListC[i].Count < num)
                    {
                        num = ListC[i].Count;
                    }
                    if (num > 1)
                    {
                        int[] array2 = Congthongso(list4[0].ID, num);
                        for (int num2 = 0; num2 < array.Length; num2++)
                        {
                            array[num2] += array2[num2];
                        }
                    }
                }
            }
            return array;
        }

        private void Save_Kill_Suit(List<int> Kill_List)
        {
            try
            {
                if (Kill_List.Count <= 0)
                {
                    return;
                }
                string text = string.Empty;
                foreach (int Kill_ in Kill_List)
                {
                    text = text + Kill_ + ",";
                }
                Suit_Manager suit_Manager = new Suit_Manager();
                suit_Manager.Kill_List = text;
                suit_Manager.UserID = base.Player.PlayerCharacter.ID;
                using ProduceBussiness produceBussiness = new ProduceBussiness();
                produceBussiness.Update_Suit_Kill(suit_Manager);
            }
            catch
            {
            }
        }

        private List<int> Load_Kill_Suit()
        {
            List<int> list = new List<int>();
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                try
                {
                    Suit_Manager suit_Manager = new Suit_Manager();
                    suit_Manager = playerBussiness.Get_Suit_Manager(base.Player.PlayerCharacter.ID);
                    if (suit_Manager.UserID > 0)
                    {
                        string text = suit_Manager.Kill_List;
                        if (text.Length > 2)
                        {
                            while (text.Contains(","))
                            {
                                int result = 0;
                                int.TryParse(text.Substring(0, text.IndexOf(",")), out result);
                                if (result == 0)
                                {
                                    return list;
                                }
                                list.Add(result);
                                text = text.Remove(0, text.IndexOf(",") + 1);
                            }
                            if (!text.Contains(","))
                            {
                                int result2 = 0;
                                int.TryParse(text, out result2);
                                if (result2 > 0)
                                {
                                    list.Add(result2);
                                    return list;
                                }
                            }
                        }
                    }
                }
                catch
                {
                }
            }
            return list;
        }

        private List<int> tachchuoi(string A)
        {
            List<int> list = new List<int>();
            if (!A.Contains(","))
            {
                list.Add(int.Parse(A));
            }
            else
            {
                while (A.Contains(","))
                {
                    int num = A.IndexOf(",");
                    if (num > 0)
                    {
                        string s = A.Substring(0, num);
                        list.Add(int.Parse(s));
                        A = A.Remove(0, num + 1);
                    }
                    if (!A.Contains(","))
                    {
                        list.Add(int.Parse(A));
                    }
                }
            }
            return list;
        }

        private int[] Congthongso(int suitID, int count)
        {
            int[] array = new int[5];
            Suit_TemplateInfo suit_TemplateInfo = GamePlayer.DS_Template_Suit_info.Find((Suit_TemplateInfo a) => a.SuitId == suitID);
            int num = 0;
            switch (count)
            {
                case 2:
                    num = int.Parse(suit_TemplateInfo.Skill2.Replace(",", ""));
                    break;
                case 3:
                    num = int.Parse(suit_TemplateInfo.Skill3.Replace(",", ""));
                    break;
                case 4:
                    num = int.Parse(suit_TemplateInfo.Skill4.Replace(",", ""));
                    break;
                case 5:
                    num = int.Parse(suit_TemplateInfo.Skill5.Replace(",", ""));
                    break;
                default:
                    return array;
            }
            switch (num)
            {
                case 1010000:
                    array[4] = 300;
                    break;
                case 1010400:
                    array[4] = 300;
                    array[0] = 10;
                    break;
                case 2000000:
                    array[4] = 300;
                    break;
                case 2000001:
                    array[0] = 20;
                    array[1] = 20;
                    array[2] = 20;
                    array[3] = 20;
                    array[4] = 300;
                    break;
                case 2000002:
                    array[0] = 20;
                    array[1] = 20;
                    array[2] = 20;
                    array[3] = 20;
                    array[4] = 300;
                    break;
                default:
                    return array;
            }
            if (num > 0)
            {
                List<int> list = new List<int>();
                list = Load_Kill_Suit();
                if (num > 0 && !list.Contains(num))
                {
                    list.Add(num);
                    Save_Kill_Suit(list);
                }
            }
            return array;
        }

        public int FindItemEpuipSlot(ItemTemplateInfo item)
        {
            switch (item.CategoryID)
            {
                case 8:
                case 28:
                    lock (m_lock)
                    {
                        if (m_items[7] == null)
                        {
                            return 7;
                        }
                    }
                    return 8;
                case 9:
                case 29:
                    lock (m_lock)
                    {
                        if (m_items[9] == null)
                        {
                            return 9;
                        }
                    }
                    return 10;
                case 13:
                    return 11;
                case 14:
                    return 12;
                case 15:
                    return 13;
                case 16:
                    return 14;
                case 27:
                    return 6;
                case 17:
                case 31:
                    return 15;
                case 40:
                    return 17;
                case 70:
                    return 18;
                case 64:
                    return 20;
                default:
                    return item.CategoryID - 1;
            }
        }

        public bool CanEquipSlotContains(int slot, ItemTemplateInfo temp)
        {
            if (temp.CategoryID == 8 || temp.CategoryID == 28)
            {
                return slot == 7 || slot == 8;
            }
            if (temp.CategoryID == 9 || temp.CategoryID == 29)
            {
                if (temp.IsRing())
                {
                    return slot == 9 || slot == 10 || slot == 16;
                }
                return slot == 9 || slot == 10;
            }
            if (temp.CategoryID == 13)
            {
                return slot == 11;
            }
            if (temp.CategoryID == 14)
            {
                return slot == 12;
            }
            if (temp.CategoryID == 15)
            {
                return slot == 13;
            }
            if (temp.CategoryID == 16)
            {
                return slot == 14;
            }
            if (temp.CategoryID == 17)
            {
                return slot == 15;
            }
            if (temp.CategoryID == 27)
            {
                return slot == 6;
            }
            if (temp.CategoryID == 40)
            {
                return slot == 17;
            }
            return temp.CategoryID - 1 == slot;
        }

        public bool IsEquipSlot(int slot)
        {
            if (slot >= 0)
            {
                return slot < 31;
            }
            return false;
        }

        public void GetUserNimbus()
        {
            int num = 0;
            int num2 = 0;
            for (int i = 0; i < 31; i++)
            {
                ItemInfo itemAt = GetItemAt(i);
                if (itemAt == null)
                {
                    continue;
                }
                int strengthenLevel = itemAt.StrengthenLevel;
                if (strengthenLevel >= 5 && strengthenLevel <= 8)
                {
                    if (itemAt.Template.CategoryID == 1 || itemAt.Template.CategoryID == 5)
                    {
                        num = ((num <= 1) ? 1 : num);
                    }
                    if (itemAt.Template.CategoryID == 7 || itemAt.Template.CategoryID == 27)
                    {
                        num2 = ((num2 <= 1) ? 1 : num2);
                    }
                }
                if (strengthenLevel >= 9 && strengthenLevel <= 11)
                {
                    if (itemAt.Template.CategoryID == 1 || itemAt.Template.CategoryID == 5)
                    {
                        num = ((num > 1) ? num : 2);
                    }
                    if (itemAt.Template.CategoryID == 7 || itemAt.Template.CategoryID == 27)
                    {
                        num2 = ((num2 > 1) ? num2 : 2);
                    }
                }
                if (strengthenLevel >= 12 && strengthenLevel <= 14)
                {
                    if (itemAt.Template.CategoryID == 1 || itemAt.Template.CategoryID == 5)
                    {
                        num = ((num > 1) ? num : 3);
                    }
                    if (itemAt.Template.CategoryID == 7 || itemAt.Template.CategoryID == 27)
                    {
                        num2 = ((num2 > 1) ? num2 : 3);
                    }
                }
                if (strengthenLevel == 15)
                {
                    if (itemAt.Template.CategoryID == 1 || itemAt.Template.CategoryID == 5)
                    {
                        num = ((num > 1) ? num : 4);
                    }
                    if (itemAt.Template.CategoryID == 7 || itemAt.Template.CategoryID == 27)
                    {
                        num2 = ((num2 > 1) ? num2 : 4);
                    }
                }
                if (itemAt.isGold)
                {
                    if (itemAt.Template.CategoryID == 1 || itemAt.Template.CategoryID == 5)
                    {
                        num = 5;
                    }
                    if (itemAt.Template.CategoryID == 7 || itemAt.Template.CategoryID == 27)
                    {
                        num2 = 5;
                    }
                }
            }
            m_player.PlayerCharacter.Nimbus = num * 100 + num2;
            m_player.Out.SendUpdatePublicPlayer(m_player.PlayerCharacter, m_player.MatchInfo, m_player.Extra.Info);
        }

        public void EquipBuffer()
        {
            m_player.EquipEffect.Clear();
            for (int i = 0; i < 31; i++)
            {
                ItemInfo itemAt = GetItemAt(i);
                if (itemAt != null)
                {
                    if (itemAt.Hole1 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole1);
                    }
                    if (itemAt.Hole2 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole2);
                    }
                    if (itemAt.Hole3 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole3);
                    }
                    if (itemAt.Hole4 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole4);
                    }
                    if (itemAt.Hole5 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole5);
                    }
                    if (itemAt.Hole6 > 0)
                    {
                        m_player.EquipEffect.Add(itemAt.Hole6);
                    }
                }
            }
        }

        public void AddProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky)
        {
            if (item != null)
            {
                if (item.Hole1 > 0)
                {
                    AddBaseProperty(item.Hole1, ref attack, ref defence, ref agility, ref lucky);
                }
                if (item.Hole2 > 0)
                {
                    AddBaseProperty(item.Hole2, ref attack, ref defence, ref agility, ref lucky);
                }
                if (item.Hole3 > 0)
                {
                    AddBaseProperty(item.Hole3, ref attack, ref defence, ref agility, ref lucky);
                }
                if (item.Hole4 > 0)
                {
                    AddBaseProperty(item.Hole4, ref attack, ref defence, ref agility, ref lucky);
                }
                if (item.Hole5 > 0)
                {
                    AddBaseProperty(item.Hole5, ref attack, ref defence, ref agility, ref lucky);
                }
                if (item.Hole6 > 0)
                {
                    AddBaseProperty(item.Hole6, ref attack, ref defence, ref agility, ref lucky);
                }
            }
        }

        public void AddBaseProperty(int templateid, ref int attack, ref int defence, ref int agility, ref int lucky)
        {
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateid);
            if (itemTemplateInfo != null && itemTemplateInfo.CategoryID == 11 && itemTemplateInfo.Property1 == 31 && itemTemplateInfo.Property2 == 3)
            {
                attack += itemTemplateInfo.Property3;
                defence += itemTemplateInfo.Property4;
                agility += itemTemplateInfo.Property5;
                lucky += itemTemplateInfo.Property6;
            }
        }

        public void AddBaseLatentProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky)
        {
            if (item != null && !item.IsValidLatentEnergy())
            {
                string[] array = item.latentEnergyCurStr.Split(new char[]
                {
                    ','
                });
                attack += Convert.ToInt32(array[0]);
                defence += Convert.ToInt32(array[1]);
                agility += Convert.ToInt32(array[2]);
                lucky += Convert.ToInt32(array[3]);
            }
        }

        public void AddBaseGemstoneProperty(ItemInfo item, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
        {
            List<UserGemStone> _gemStone = m_player.GemStone;
            foreach (UserGemStone gem in _gemStone)
            {
                try
                {
                    string[] values = gem.FigSpiritIdValue.Split('|');

                    int id = gem.FigSpiritId;
                    int place = item.Place;
                    for (int i = 0; i < values.Length; i++)
                    {
                        int lv = Convert.ToInt32(values[i].Split(',')[0]);
                        switch (item.Place)
                        {
                            case 2:
                                attack += FightSpiritTemplateMgr.getProp(id, lv, place);
                                break;
                            case 11:
                                defence += FightSpiritTemplateMgr.getProp(id, lv, place);
                                break;
                            case 5:
                                agility += FightSpiritTemplateMgr.getProp(id, lv, place);
                                break;
                            case 3:
                                lucky += FightSpiritTemplateMgr.getProp(id, lv, place);
                                break;
                            case 13:
                                hp += FightSpiritTemplateMgr.getProp(id, lv, place);
                                break;
                        }
                    }
                }
                catch
                {
                    log.ErrorFormat("Add Base Gemstone UserID: {0}, UserName: {1}, FigSpiritId {2}, FigSpiritIdValue: {3}, have error can not get Property", m_player.PlayerCharacter.ID, m_player.PlayerCharacter.UserName, gem.FigSpiritId, gem.FigSpiritIdValue);
                }
            }
        }

        public void AddBaseTotemProperty(int totemId, ref int attack, ref int defence, ref int agility, ref int lucky, ref int hp)
        {
            attack += TotemMgr.GetTotemProp(totemId, "att");
            defence += TotemMgr.GetTotemProp(totemId, "def");
            agility += TotemMgr.GetTotemProp(totemId, "agi");
            lucky += TotemMgr.GetTotemProp(totemId, "luc");
            hp += TotemMgr.GetTotemProp(totemId, "blo");
        }

        public void AddBaseRankProperty(ref int attack, ref int defence, ref int agility, ref int lucky)
        {
            if (Player.PlayerCharacter.ID > 0)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    List<UserRankInfo> singleUserRank = pb.GetSingleUserRank(Player.PlayerCharacter.ID);
                    if (singleUserRank != null)
                    {
                        foreach (var item in singleUserRank)
                        {
                            if(item.IsValidRank())
                            {
                                attack += item.Attack;
                                defence += item.Defence;
                                agility += item.Agility;
                                lucky += item.Luck;
                                if (NewTitleMgr.FindNewTitle(item.NewTitleID) != null)
                                {
                                    attack += NewTitleMgr.FindNewTitle(item.NewTitleID).Att;
                                    defence += NewTitleMgr.FindNewTitle(item.NewTitleID).Def;
                                    agility += NewTitleMgr.FindNewTitle(item.NewTitleID).Agi;
                                    lucky += NewTitleMgr.FindNewTitle(item.NewTitleID).Luck;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
