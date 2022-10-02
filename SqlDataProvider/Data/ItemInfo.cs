using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class ItemInfo : DataObject
    {
        private int _agilityCompose;

        private int _attackCompose;

        private int _bagType;

        private DateTime _beginDate;

        private string _color;

        private int _count;

        private int _defendCompose;

        private DateTime _goldBeginTime;

        private ItemTemplateInfo _goldEquip;

        private int _goldValidDate;

        private int _hole1;

        private int _hole2;

        private int _hole3;

        private int _hole4;

        private int _hole5;

        private int _hole5Exp;

        private int _hole5Level;

        private int _hole6;

        private int _hole6Exp;

        private int _hole6Level;

        private bool _isBinds;

        private bool _isExist;

        private bool _isGold;

        private bool _isJudage;

        private bool _isLogs;

        private bool _isTips;

        private bool _isUsed;

        private int _itemID;

        private int _luckCompose;

        private int _place;

        private DateTime _removeDate;

        private int _removeType;

        private string _skin;

        private int _strengthenLevel;

        private int _strengthenExp;

        private int _strengthenTimes;

        private ItemTemplateInfo _template;

        private int _templateId;

        private int _userID;

        private int _validDate;

        private int _Blood;

        private string _latentEnergyCurStr;

        private string _latentEnergyNewStr;

        private DateTime _latentEnergyEndTime;

        public int Agility
        {
            get
            {
                int agility = _template.Agility;
                if (IsGold && GoldEquip != null)
                {
                    agility = GoldEquip.Agility;
                }
                return _agilityCompose + agility;
            }
        }

        public int AgilityCompose
        {
            get
            {
                return _agilityCompose;
            }
            set
            {
                _agilityCompose = value;
                _isDirty = true;
            }
        }

        public int Attack
        {
            get
            {
                int attack = _template.Attack;
                if (IsGold && GoldEquip != null)
                {
                    attack = GoldEquip.Attack;
                }
                return _attackCompose + attack;
            }
        }

        public int AttackCompose
        {
            get
            {
                return _attackCompose;
            }
            set
            {
                _attackCompose = value;
                _isDirty = true;
            }
        }

        public int BagType
        {
            get
            {
                return _bagType;
            }
            set
            {
                _bagType = value;
                _isDirty = true;
            }
        }

        public DateTime BeginDate
        {
            get
            {
                return _beginDate;
            }
            set
            {
                _beginDate = value;
                _isDirty = true;
            }
        }

        public string Color
        {
            get
            {
                return _color;
            }
            set
            {
                _color = value;
                _isDirty = true;
            }
        }

        public int Count
        {
            get
            {
                return _count;
            }
            set
            {
                _count = value;
                _isDirty = true;
            }
        }

        public int Defence
        {
            get
            {
                int defence = _template.Defence;
                if (IsGold && GoldEquip != null)
                {
                    defence = GoldEquip.Defence;
                }
                return _defendCompose + defence;
            }
        }

        public int DefendCompose
        {
            get
            {
                return _defendCompose;
            }
            set
            {
                _defendCompose = value;
                _isDirty = true;
            }
        }

        public int GetBagType => (int)_template.BagType;

        public DateTime goldBeginTime
        {
            get
            {
                return _goldBeginTime;
            }
            set
            {
                _goldBeginTime = value;
                _isDirty = true;
            }
        }

        public ItemTemplateInfo GoldEquip
        {
            get
            {
                if (_goldEquip == null)
                    return _template;

                return _goldEquip;
            }
            set
            {
                _goldEquip = value;
                _isDirty = true;
            }
        }

        public int goldValidDate
        {
            get
            {
                return _goldValidDate;
            }
            set
            {
                _goldValidDate = value;
                _isDirty = true;
            }
        }

        public int Hole1
        {
            get
            {
                return _hole1;
            }
            set
            {
                _hole1 = value;
                _isDirty = true;
            }
        }

        public int Hole2
        {
            get
            {
                return _hole2;
            }
            set
            {
                _hole2 = value;
                _isDirty = true;
            }
        }

        public int Hole3
        {
            get
            {
                return _hole3;
            }
            set
            {
                _hole3 = value;
                _isDirty = true;
            }
        }

        public int Hole4
        {
            get
            {
                return _hole4;
            }
            set
            {
                _hole4 = value;
                _isDirty = true;
            }
        }

        public int Hole5
        {
            get
            {
                return _hole5;
            }
            set
            {
                _hole5 = value;
                _isDirty = true;
            }
        }

        public int Hole5Exp
        {
            get
            {
                return _hole5Exp;
            }
            set
            {
                _hole5Exp = value;
                _isDirty = true;
            }
        }

        public int Hole5Level
        {
            get
            {
                return _hole5Level;
            }
            set
            {
                _hole5Level = value;
                _isDirty = true;
            }
        }

        public int Hole6
        {
            get
            {
                return _hole6;
            }
            set
            {
                _hole6 = value;
                _isDirty = true;
            }
        }

        public int Blood
        {
            get
            {
                return _Blood;
            }
            set
            {
                _Blood = value;
                _isDirty = true;
            }
        }

        public int Hole6Exp
        {
            get
            {
                return _hole6Exp;
            }
            set
            {
                _hole6Exp = value;
                _isDirty = true;
            }
        }

        public int Hole6Level
        {
            get
            {
                return _hole6Level;
            }
            set
            {
                _hole6Level = value;
                _isDirty = true;
            }
        }

        public bool IsBinds
        {
            get
            {
                return _isBinds;
            }
            set
            {
                _isBinds = value;
                _isDirty = true;
            }
        }

        public bool IsExist
        {
            get
            {
                return _isExist;
            }
            set
            {
                _isExist = value;
                _isDirty = true;
            }
        }

        public bool IsGold => IsValidGoldItem();

        public bool IsJudge
        {
            get
            {
                return _isJudage;
            }
            set
            {
                _isJudage = value;
                _isDirty = true;
            }
        }

        public bool IsLogs
        {
            get
            {
                return _isLogs;
            }
            set
            {
                _isLogs = value;
            }
        }

        public bool IsTips
        {
            get
            {
                return _isTips;
            }
            set
            {
                _isTips = value;
            }
        }

        public bool IsUsed
        {
            get
            {
                return _isUsed;
            }
            set
            {
                if (_isUsed != value)
                {
                    _isUsed = value;
                    _isDirty = true;
                }
            }
        }

        public int ItemID
        {
            get
            {
                return _itemID;
            }
            set
            {
                _itemID = value;
                _isDirty = true;
            }
        }

        public int Luck
        {
            get
            {
                int luck = _template.Luck;
                if (IsGold && GoldEquip != null)
                {
                    luck = GoldEquip.Luck;
                }
                return _luckCompose + luck;
            }
        }

        public int LuckCompose
        {
            get
            {
                return _luckCompose;
            }
            set
            {
                _luckCompose = value;
                _isDirty = true;
            }
        }

        public string Pic
        {
            get
            {
                if (IsGold && GoldEquip != null)
                {
                    return GoldEquip.Pic;
                }
                return _template.Pic;
            }
        }

        public int Place
        {
            get
            {
                return _place;
            }
            set
            {
                _place = value;
                _isDirty = true;
            }
        }

        public int RefineryLevel
        {
            get
            {
                if (IsGold && GoldEquip != null)
                {
                    return GoldEquip.RefineryLevel;
                }
                return _template.RefineryLevel;
            }
        }

        public DateTime RemoveDate
        {
            get
            {
                return _removeDate;
            }
            set
            {
                _removeDate = value;
                _isDirty = true;
            }
        }

        public int RemoveType
        {
            get
            {
                return _removeType;
            }
            set
            {
                _removeType = value;
                _removeDate = DateTime.Now;
                _isDirty = true;
            }
        }

        public string Skin
        {
            get
            {
                return _skin;
            }
            set
            {
                _skin = value;
                _isDirty = true;
            }
        }

        public int StrengthenLevel
        {
            get
            {
                return _strengthenLevel;
            }
            set
            {
                _strengthenLevel = value;
                _isDirty = true;
            }
        }

        public int StrengthenExp
        {
            get
            {
                return _strengthenExp;
            }
            set
            {
                _strengthenExp = value;
                _isDirty = true;
            }
        }

        public int StrengthenTimes
        {
            get
            {
                return _strengthenTimes;
            }
            set
            {
                _strengthenTimes = value;
                _isDirty = true;
            }
        }

        public ItemTemplateInfo Template => _template;

        public int TemplateID
        {
            get
            {
                if (IsGold && GoldEquip != null)
                {
                    return GoldEquip.TemplateID;
                }
                return _templateId;
            }
            set
            {
                _templateId = value;
                _isDirty = true;
            }
        }

        public int UserID
        {
            get
            {
                return _userID;
            }
            set
            {
                _userID = value;
                _isDirty = true;
            }
        }

        public int ValidDate
        {
            get
            {
                return _validDate;
            }
            set
            {
                _validDate = ((value > 999) ? 365 : value);
                _isDirty = true;
            }
        }

        public string latentEnergyCurStr
        {
            get
            {
                return this._latentEnergyCurStr;
            }
            set
            {
                this._latentEnergyCurStr = value;
                this._isDirty = true;
            }
        }
        public string latentEnergyNewStr
        {
            get
            {
                return this._latentEnergyNewStr;
            }
            set
            {
                this._latentEnergyNewStr = value;
                this._isDirty = true;
            }
        }
        public DateTime latentEnergyEndTime
        {
            get
            {
                return this._latentEnergyEndTime;
            }
            set
            {
                this._latentEnergyEndTime = value;
                this._isDirty = true;
            }
        }

        public bool isGold => IsValidGoldItem();

        public ItemInfo(ItemTemplateInfo temp)
        {
            _template = temp;
        }

        public bool CanEquip()
        {
            if (_template.CategoryID >= 10)
            {
                if (_template.CategoryID >= 13)
                {
                    return _template.CategoryID <= 16;
                }
                return false;
            }
            return true;
        }

        public bool CanStackedTo(ItemInfo to)
        {
            if (_templateId == to.TemplateID && Template.MaxCount > 1 && _isBinds == to.IsBinds && _isUsed == to._isUsed)
            {
                if (ValidDate == 0 || (BeginDate.Date == to.BeginDate.Date && ValidDate == ValidDate))
                {
                    return true;
                }
            }
            else if (_templateId == to.TemplateID && Equip.isDress(Template) && Equip.isDress(to.Template) && to.StrengthenLevel <= 0)
            {
                return true;
            }
            return false;
        }

        public ItemInfo Clone()
        {
            return new ItemInfo(_template)
            {
                _userID = _userID,
                _validDate = _validDate,
                _templateId = _templateId,
                _goldEquip = _goldEquip,
                _strengthenLevel = _strengthenLevel,
                _luckCompose = _luckCompose,
                _itemID = 0,
                _isJudage = _isJudage,
                _isExist = _isExist,
                _isBinds = _isBinds,
                _isUsed = _isUsed,
                _defendCompose = _defendCompose,
                _count = _count,
                _color = _color,
                Skin = _skin,
                _beginDate = _beginDate,
                _attackCompose = _attackCompose,
                _agilityCompose = _agilityCompose,
                _bagType = _bagType,
                _isDirty = true,
                _removeDate = _removeDate,
                _removeType = _removeType,
                _hole1 = _hole1,
                _hole2 = _hole2,
                _hole3 = _hole3,
                _hole4 = _hole4,
                _hole5 = _hole5,
                _hole6 = _hole6,
                _hole5Exp = _hole5Exp,
                _hole5Level = _hole5Level,
                _hole6Exp = _hole6Exp,
                _hole6Level = _hole6Level,
                _isGold = _isGold,
                _goldBeginTime = _goldBeginTime,
                _goldValidDate = _goldValidDate,
                _latentEnergyCurStr = _latentEnergyCurStr,
                _latentEnergyNewStr = _latentEnergyNewStr,
                _latentEnergyEndTime = _latentEnergyEndTime
            };
        }

        public static ItemInfo CloneFromTemplate(ItemTemplateInfo goods, ItemInfo item)
        {
            if (goods == null)
            {
                return null;
            }
            ItemInfo info = new ItemInfo(goods)
            {
                GoldEquip = item.GoldEquip,
                AgilityCompose = item.AgilityCompose,
                AttackCompose = item.AttackCompose,
                BeginDate = item.BeginDate,
                Color = item.Color,
                Skin = item.Skin,
                DefendCompose = item.DefendCompose,
                IsBinds = item.IsBinds,
                Place = item.Place,
                BagType = item.BagType,
                IsUsed = item.IsUsed,
                IsDirty = item.IsDirty,
                IsExist = item.IsExist,
                IsJudge = item.IsJudge,
                LuckCompose = item.LuckCompose,
                StrengthenLevel = item.StrengthenLevel,
                TemplateID = goods.TemplateID,
                ValidDate = item.ValidDate,
                _template = goods,
                Count = item.Count,
                _removeDate = item._removeDate,
                _removeType = item._removeType,
                Hole1 = item.Hole1,
                Hole2 = item.Hole2,
                Hole3 = item.Hole3,
                Hole4 = item.Hole4,
                Hole5 = item.Hole5,
                Hole6 = item.Hole6,
                Hole5Level = item.Hole5Level,
                Hole5Exp = item.Hole5Exp,
                Hole6Level = item.Hole6Level,
                Hole6Exp = item.Hole6Exp,
                goldBeginTime = item.goldBeginTime,
                goldValidDate = item.goldValidDate,
                StrengthenExp = item.StrengthenExp,
                latentEnergyEndTime = item.latentEnergyEndTime,
                latentEnergyCurStr = item.latentEnergyCurStr,
                latentEnergyNewStr = item.latentEnergyNewStr
            };
            OpenHole(ref info);
            return info;
        }

        public void Copy(ItemInfo item)
        {
            _userID = item.UserID;
            _validDate = item.ValidDate;
            _templateId = item.TemplateID;
            _strengthenLevel = item.StrengthenLevel;
            _luckCompose = item.LuckCompose;
            _itemID = 0;
            _isJudage = item.IsJudge;
            _isExist = item.IsExist;
            _isBinds = item.IsBinds;
            _isUsed = item.IsUsed;
            _defendCompose = item.DefendCompose;
            _count = item.Count;
            _color = item.Color;
            _skin = item.Skin;
            _beginDate = item.BeginDate;
            _attackCompose = item.AttackCompose;
            _agilityCompose = item.AgilityCompose;
            _bagType = item.BagType;
            _isDirty = item.IsDirty;
            _removeDate = item.RemoveDate;
            _removeType = item.RemoveType;
            _hole1 = item.Hole1;
            _hole2 = item.Hole2;
            _hole3 = item.Hole3;
            _hole4 = item.Hole4;
            _hole5 = item.Hole5;
            _hole6 = item.Hole6;
            _hole5Exp = item.Hole5Exp;
            _hole5Level = item.Hole5Level;
            _hole6Exp = item.Hole6Exp;
            _hole6Level = item.Hole6Level;
            _isGold = item.IsGold;
            _goldBeginTime = item.goldBeginTime;
            _goldValidDate = item.goldValidDate;
        }

        public static ItemInfo CreateFromTemplate(ItemTemplateInfo goods, int count, int type)
        {
            if (goods == null)
            {
                return null;
            }
            return new ItemInfo(goods)
            {
                AgilityCompose = 0,
                AttackCompose = 0,
                BeginDate = DateTime.Now,
                Color = "",
                Skin = "",
                DefendCompose = 0,
                IsUsed = false,
                IsDirty = false,
                IsExist = true,
                IsJudge = true,
                LuckCompose = 0,
                StrengthenLevel = 0,
                TemplateID = goods.TemplateID,
                ValidDate = 0,
                Count = count,
                IsBinds = (goods.BindType == 1),
                _removeDate = DateTime.Now,
                _removeType = type,
                Hole1 = -1,
                Hole2 = -1,
                Hole3 = -1,
                Hole4 = -1,
                Hole5 = -1,
                Hole6 = -1,
                Hole5Exp = 0,
                Hole5Level = 0,
                Hole6Exp = 0,
                Hole6Level = 0,
                goldValidDate = 0,
                goldBeginTime = DateTime.Now,
                Blood = 0,
                latentEnergyCurStr = "0,0,0,0",
                latentEnergyNewStr = "0,0,0,0",
                latentEnergyEndTime = DateTime.Now
            };
        }

        public int eqType()
        {
            return _template.CategoryID switch
            {
                51 => 1,
                52 => 2,
                _ => 0,
            };
        }

        public static void FindSpecialItemInfo(ItemInfo info, SpecialItemDataInfo specialInfo)
        {
            switch (info.TemplateID)
            {
                case -200:
                    specialInfo.Money += info.Count;
                    info = null;
                    break;
                case -300:
                    specialInfo.GiftToken += info.Count;
                    info = null;
                    break;
                case 11107:
                    specialInfo.GP += info.Count;
                    info = null;
                    break;
                case -100:
                    specialInfo.Gold += info.Count;
                    info = null;
                    break;
            }
        }

        public static ItemInfo FindSpecialItemInfo(ItemInfo info, ref int gold, ref int money, ref int giftToken)
        {
            int gp = 0;
            return FindSpecialItemInfo(info, ref gold, ref money, ref giftToken, ref gp);
        }

        public static ItemInfo FindSpecialItemInfo(ItemInfo info, ref int gold, ref int money, ref int giftToken, ref int gp)
        {
            switch (info.TemplateID)
            {
                case -300:
                    giftToken += info.Count;
                    info = null;
                    break;
                case -200:
                    money += info.Count;
                    info = null;
                    break;
                case -100:
                    gold += info.Count;
                    info = null;
                    break;
                case 11107:
                    gp += info.Count;
                    info = null;
                    break;
            }
            return info;
        }

        public string GetBagName()
        {
            switch (_template.CategoryID)
            {
                case 10:
                case 11:
                    return "Game.Server.GameObjects.Prop";
                case 12:
                    return "Game.Server.GameObjects.Task";
                default:
                    return "Game.Server.GameObjects.Equip";
            }
        }

        public static void GetItemPrice(int Prices, int Values, decimal beat, ref int gold, ref int money, ref int offer, ref int gifttoken, ref int petScore, ref int Score, ref int dmgScore, ref int iTemplateID, ref int iCount)
        {
            iTemplateID = 0;
            iCount = 0;
            switch (Prices)
            {
                case -4:
                    gifttoken += (int)((decimal)Values * beat);
                    return;
                case -3:
                    offer += (int)((decimal)Values * beat);
                    return;
                case -2:
                    gold += (int)((decimal)Values * beat);
                    return;
                case -1:
                    money += (int)((decimal)Values * beat);
                    return;
                case -8:
                    petScore += (int)((decimal)Values * beat);
                    return;
                case -6:
                    Score += (int)((decimal)Values * beat);
                    return;
                case -9:
                    dmgScore += (int)((decimal)Values * beat);
                    return;
            }
            if (Prices > 0)
            {
                iTemplateID = Prices;
                iCount = Values;
            }
        }

        public int GetRemainDate()
        {
            if (ValidDate == 0)
            {
                return int.MaxValue;
            }
            if (!_isUsed)
            {
                return ValidDate;
            }
            int num = DateTime.Compare(_beginDate.AddDays(_validDate), DateTime.Now);
            if (num >= 0)
            {
                return num;
            }
            return 0;
        }

        public bool IsBead()
        {
            if (_template.Property1 == 31)
            {
                return _template.CategoryID == 11;
            }
            return false;
        }

        public bool IsCard()
        {
            int categoryID = _template.CategoryID;
            if (categoryID != 11)
            {
                return categoryID == 18;
            }
            if (_template.TemplateID != 112108)
            {
                return _template.TemplateID == 112150;
            }
            return true;
        }

        public bool isDress()
        {
            switch (_template.CategoryID)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 13:
                case 15:
                    return true;
                default:
                    return false;
            }
        }

        public bool isDrill(int holelv)
        {
            return _template.TemplateID switch
            {
                11026 => holelv == 2,
                11027 => holelv == 3,
                11034 => holelv == 4,
                11035 => holelv == 0,
                11036 => holelv == 1,
                _ => false,
            };
        }

        public bool IsEquipPet()
        {
            if (_template == null)
            {
                return false;
            }
            if (_template.CategoryID == 50 || _template.CategoryID == 51 || _template.CategoryID == 52)
            {
                return true;
            }
            return false;
        }

        public bool isGemStone()
        {
            return _template.TemplateID == 100100;
        }

        public bool IsProp()
        {
            int categoryID = _template.CategoryID;
            if (categoryID <= 18)
            {
                if (categoryID != 11 && categoryID != 18)
                {
                    return false;
                }
            }
            else
            {
                switch (categoryID)
                {
                    case 33:
                        return false;
                    default:
                        return false;
                    case 32:
                    case 34:
                    case 35:
                    case 40:
                        break;
                }
            }
            return true;
        }

        public bool isTexp()
        {
            return _template.CategoryID == 20;
        }

        public bool IsValidGoldItem()
        {
            if (_goldValidDate > 0)
            {
                return DateTime.Compare(_goldBeginTime.AddDays(_goldValidDate), DateTime.Now) > 0;
            }
            return false;
        }

        public bool IsValidItem()
        {
            if (_validDate != 0 && _isUsed)
            {
                return DateTime.Compare(_beginDate.AddDays(_validDate), DateTime.Now) > 0;
            }
            return true;
        }

        public static void OpenHole(ref ItemInfo item)
        {
            string[] strArray = item.Template.Hole.Split('|');
            for (int i = 0; i < strArray.Length; i++)
            {
                string[] strArray2 = strArray[i].Split(',');
                if (item.StrengthenLevel < Convert.ToInt32(strArray2[0]) || Convert.ToInt32(strArray2[1]) == -1)
                {
                    continue;
                }
                switch (i)
                {
                    case 0:
                        if (item.Hole1 < 0)
                        {
                            item.Hole1 = 0;
                        }
                        break;
                    case 1:
                        if (item.Hole2 < 0)
                        {
                            item.Hole2 = 0;
                        }
                        break;
                    case 2:
                        if (item.Hole3 < 0)
                        {
                            item.Hole3 = 0;
                        }
                        break;
                    case 3:
                        if (item.Hole4 < 0)
                        {
                            item.Hole4 = 0;
                        }
                        break;
                    case 4:
                        if (item.Hole5 < 0)
                        {
                            item.Hole5 = 0;
                        }
                        break;
                    case 5:
                        if (item.Hole6 < 0)
                        {
                            item.Hole6 = 0;
                        }
                        break;
                }
            }
        }

        public static List<int> SetItemType(ShopItemInfo shop, int type, ref int gold, ref int money, ref int offer, ref int gifttoken, ref int petScore, ref int Score, ref int dmgScore)
        {
            int iTemplateID = 0;
            int iCount = 0;
            List<int> list = new List<int>();
            if (type == 1)
            {
                GetItemPrice(shop.APrice1, shop.AValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.APrice2, shop.AValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.APrice3, shop.AValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
            }
            if (type == 2)
            {
                GetItemPrice(shop.BPrice1, shop.BValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.BPrice2, shop.BValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.BPrice3, shop.BValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
            }
            if (type == 3)
            {
                GetItemPrice(shop.CPrice1, shop.CValue1, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.CPrice2, shop.CValue2, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
                GetItemPrice(shop.CPrice3, shop.CValue3, shop.Beat, ref gold, ref money, ref offer, ref gifttoken, ref petScore, ref Score, ref dmgScore, ref iTemplateID, ref iCount);
                if (iTemplateID > 0)
                {
                    list.Add(iTemplateID);
                    list.Add(iCount);
                }
            }
            return list;
        }

        public int GetBagTypee()
        {
            switch (_template.CategoryID)
            {
                case 10:
                case 11:
                    return 1;
                case 12:
                    return 2;
                default:
                    return 0;
            }
        }

        public void ResetLatentEnergy()
        {
            this._latentEnergyCurStr = "0,0,0,0,0,0,0";
            this._latentEnergyNewStr = "0,0,0,0,0,0,0";
        }

        public bool IsValidLatentEnergy()
        {
            return _latentEnergyEndTime.Date < DateTime.Now.Date;
        }

        public bool CanLatentEnergy()
        {
            int categoryID = this.Template.CategoryID;
            switch (categoryID)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 13:
                case 14:
                case 15:
                case 16:
                case 17:
                case 40:
                    return true;
                default:
                    return false;
            }
        }

        public string Name => this.Template.CategoryID == 11 && this.Template.Property1 == 31 ? this.Template.Data : this.Template.Name;
    }
}