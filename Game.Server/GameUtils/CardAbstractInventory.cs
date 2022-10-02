using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.GameUtils
{
    public abstract class CardAbstractInventory
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock;

        private int _capability;

        private int _beginSlot;

        protected UsersCardInfo[] m_cards;

        protected UsersCardInfo temp_card;

        protected List<int> m_changedPlaces;

        private int _location;

        public int BeginSlot => _beginSlot;

        public int Capalility
        {
            get
            {
                return _capability;
            }
            set
            {
                _capability = ((value >= 0) ? ((value > m_cards.Length) ? m_cards.Length : value) : 0);
            }
        }

        public bool IsEmpty(int slot)
        {
            if (slot >= 0 && slot < _capability)
            {
                return m_cards[slot] == null;
            }
            return true;
        }

        public CardAbstractInventory(int capability, int beginSlot)
        {
            m_lock = new object();
            m_changedPlaces = new List<int>();
            this._capability = capability;
            _beginSlot = beginSlot;
            m_cards = new UsersCardInfo[capability];
            temp_card = new UsersCardInfo();
        }

        public virtual void UpdateTempCard(UsersCardInfo card)
        {
            lock (m_lock)
            {
                temp_card = card;
            }
        }

        public virtual void UpdateCard(UsersCardInfo card)
        {
            OnPlaceChanged(card.Place);
        }

        public virtual void UpdateCard()
        {
            int place = temp_card.Place;
            int templateID = temp_card.TemplateID;
            if (place < 5)
            {
                ReplaceCardTo(temp_card, place);
                int toSlot = FindPlaceByTamplateId(5, templateID);
                MoveCard(place, toSlot);
                return;
            }
            ReplaceCardTo(temp_card, place);
            int num = FindPlaceByTamplateId(0, 5, templateID);
            if (GetItemAt(num) != null && GetItemAt(num).TemplateID == templateID)
            {
                MoveCard(place, num);
            }
        }

        public bool AddCard(UsersCardInfo card)
        {
            return AddCard(card, _beginSlot);
        }

        public bool AddCard(UsersCardInfo card, int minSlot)
        {
            if (card == null)
            {
                return false;
            }
            int place = FindFirstEmptySlot(minSlot);
            return AddCardTo(card, place);
        }

        public virtual bool AddCardTo(UsersCardInfo card, int place)
        {
            if (card == null || place >= _capability || place < 0)
            {
                return false;
            }
            lock (m_lock)
            {
                if (m_cards[place] != null)
                {
                    place = -1;
                }
                else
                {
                    m_cards[place] = card;
                    card.Place = place;
                }
            }
            if (place != -1)
            {
                OnPlaceChanged(place);
            }
            return place != -1;
        }

        public virtual bool RemoveCardAt(int place)
        {
            return RemoveCard(GetItemAt(place));
        }

        public virtual bool RemoveCard(UsersCardInfo item)
        {
            if (item == null)
            {
                return false;
            }
            int num = -1;
            lock (m_lock)
            {
                for (int i = 0; i < _capability; i++)
                {
                    if (m_cards[i] == item)
                    {
                        num = i;
                        m_cards[i] = null;
                        break;
                    }
                }
            }
            if (num != -1)
            {
                OnPlaceChanged(num);
                item.Place = -1;
            }
            return num != -1;
        }

        public virtual bool ReplaceCardTo(UsersCardInfo card, int place)
        {
            if (card == null || place >= _capability || place < 0)
            {
                return false;
            }
            lock (m_lock)
            {
                if (m_cards[place] != null)
                {
                    RemoveCard(m_cards[place]);
                }
                m_cards[place] = card;
                card.Place = place;
                OnPlaceChanged(place);
            }
            return true;
        }

        public virtual bool MoveCard(int fromSlot, int toSlot)
        {
            if (fromSlot < 0 || toSlot < 0 || fromSlot >= _capability || toSlot >= _capability)
            {
                return false;
            }
            bool flag = false;
            lock (m_lock)
            {
                flag = StackCards(fromSlot, toSlot) || ExchangeCards(fromSlot, toSlot);
            }
            if (flag)
            {
                BeginChanges();
                try
                {
                    OnPlaceChanged(fromSlot);
                    OnPlaceChanged(toSlot);
                    return flag;
                }
                finally
                {
                    CommitChanges();
                }
            }
            return flag;
        }

        protected virtual bool StackCards(int fromSlot, int toSlot)
        {
            UsersCardInfo usersCardInfo = m_cards[fromSlot];
            UsersCardInfo usersCardInfo2 = m_cards[toSlot];
            if (usersCardInfo == null || usersCardInfo2 == null || usersCardInfo2.TemplateID != usersCardInfo.TemplateID)
            {
                return false;
            }
            usersCardInfo2.Count += usersCardInfo.Count;
            RemoveCard(usersCardInfo);
            return true;
        }

        public bool IsSolt(int slot)
        {
            if (slot >= 0)
            {
                return slot < _capability;
            }
            return false;
        }

        protected virtual bool ExchangeCards(int fromSlot, int toSlot)
        {
            UsersCardInfo usersCardInfo = m_cards[toSlot];
            UsersCardInfo usersCardInfo2 = m_cards[fromSlot];
            m_cards[fromSlot] = usersCardInfo;
            m_cards[toSlot] = usersCardInfo2;
            if (usersCardInfo != null)
            {
                usersCardInfo.Place = fromSlot;
            }
            if (usersCardInfo2 != null)
            {
                usersCardInfo2.Place = toSlot;
            }
            return true;
        }

        public virtual bool ResetCardSoul()
        {
            lock (m_lock)
            {
                for (int i = 0; i < 5; i++)
                {
                    m_cards[i].Level = 0;
                    m_cards[i].CardGP = 0;
                }
            }
            return true;
        }

        public virtual bool UpGraceSlot(int soulPoint, int lv, int place)
        {
            lock (m_lock)
            {
                m_cards[place].CardGP += soulPoint;
                m_cards[place].Level = lv;
            }
            return true;
        }

        public virtual UsersCardInfo GetItemAt(int slot)
        {
            if (slot >= 0 && slot < _capability)
            {
                return m_cards[slot];
            }
            return null;
        }

        public virtual List<UsersCardInfo> GetEquipCard()
        {
            List<UsersCardInfo> list = new List<UsersCardInfo>();
            for (int i = 0; i < 5; i++)
            {
                if (m_cards[i] != null)
                {
                    list.Add(m_cards[i]);
                }
            }
            return list;
        }

        public int FindFirstEmptySlot()
        {
            return FindFirstEmptySlot(_beginSlot);
        }

        public int FindFirstEmptySlot(int minSlot)
        {
            if (minSlot >= _capability)
            {
                return -1;
            }
            lock (m_lock)
            {
                for (int i = minSlot; i < _capability; i++)
                {
                    if (m_cards[i] == null)
                    {
                        return i;
                    }
                }
                return -1;
            }
        }

        public int FindPlaceByTamplateId(int minSlot, int templateId)
        {
            if (minSlot >= _capability)
            {
                return -1;
            }
            lock (m_lock)
            {
                for (int i = minSlot; i < _capability; i++)
                {
                    if (m_cards[i] != null && m_cards[i].TemplateID == templateId)
                    {
                        return m_cards[i].Place;
                    }
                }
                return -1;
            }
        }

        public bool FindEquipCard(int templateId)
        {
            lock (m_lock)
            {
                for (int i = 0; i < 5; i++)
                {
                    if (m_cards[i].TemplateID == templateId)
                    {
                        return true;
                    }
                }
                return false;
            }
        }

        public int FindPlaceByTamplateId(int minSlot, int maxSlot, int templateId)
        {
            if (minSlot >= _capability)
            {
                return -1;
            }
            lock (m_lock)
            {
                for (int i = minSlot; i < maxSlot; i++)
                {
                    if (m_cards[i] != null && m_cards[i].TemplateID == templateId)
                    {
                        return m_cards[i].Place;
                    }
                }
                return -1;
            }
        }

        public int FindLastEmptySlot()
        {
            lock (m_lock)
            {
                for (int num = _capability - 1; num >= 0; num--)
                {
                    if (m_cards[num] == null)
                    {
                        return num;
                    }
                }
                return -1;
            }
        }

        public virtual void Clear()
        {
            lock (m_lock)
            {
                for (int i = 0; i < _capability; i++)
                {
                    m_cards[i] = null;
                }
            }
        }

        public virtual UsersCardInfo GetItemByTemplateID(int templateId)
        {
            return GetItemByTemplateID(_beginSlot, templateId);
        }

        public virtual UsersCardInfo GetItemByTemplateID(int minSlot, int templateId)
        {
            lock (m_lock)
            {
                for (int i = minSlot; i < _capability; i++)
                {
                    if (m_cards[i] != null && m_cards[i].TemplateID == templateId)
                    {
                        return m_cards[i];
                    }
                }
                return null;
            }
        }

        public virtual UsersCardInfo GetItemByPlace(int minSlot, int place)
        {
            lock (m_lock)
            {
                for (int i = minSlot; i < _capability; i++)
                {
                    if (m_cards[i] != null && m_cards[i].Place == place)
                    {
                        return m_cards[i];
                    }
                }
                return null;
            }
        }

        public virtual List<UsersCardInfo> GetCards()
        {
            return GetCards(0, _capability - 1);
        }

        public virtual List<UsersCardInfo> GetCards(int minSlot, int maxSlot)
        {
            List<UsersCardInfo> list = new List<UsersCardInfo>();
            lock (m_lock)
            {
                for (int i = minSlot; i <= maxSlot; i++)
                {
                    if (m_cards[i] != null)
                    {
                        list.Add(m_cards[i]);
                    }
                }
                return list;
            }
        }

        public UsersCardInfo GetCardEquip(int templateid)
        {
            foreach (UsersCardInfo card in GetCards(0, 4))
            {
                if (card.TemplateID == templateid)
                {
                    return card;
                }
            }
            return null;
        }

        public int GetEmptyCount()
        {
            return GetEmptyCount(_beginSlot);
        }

        public virtual int GetEmptyCount(int minSlot)
        {
            if (minSlot < 0 || minSlot > _capability - 1)
            {
                return 0;
            }
            int num = 0;
            lock (m_lock)
            {
                for (int i = minSlot; i < _capability; i++)
                {
                    if (m_cards[i] == null)
                    {
                        num++;
                    }
                }
                return num;
            }
        }

        protected void OnPlaceChanged(int place)
        {
            if (!m_changedPlaces.Contains(place))
            {
                m_changedPlaces.Add(place);
            }
            if (_location <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }

        public void BeginChanges()
        {
            Interlocked.Increment(ref _location);
        }

        public void CommitChanges()
        {
            int num = Interlocked.Decrement(ref _location);
            if (num < 0)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Inventory changes counter is bellow zero (forgot to use BeginChanges?)!\n\n" + Environment.StackTrace);
                }
                Thread.VolatileWrite(ref _location, 0);
            }
            if (num <= 0 && m_changedPlaces.Count > 0)
            {
                UpdateChangedPlaces();
            }
        }

        public virtual void UpdateChangedPlaces()
        {
            m_changedPlaces.Clear();
        }

        public void ClearBag()
        {
            BeginChanges();
            lock (m_lock)
            {
                for (int i = 5; i < _capability; i++)
                {
                    if (m_cards[i] != null)
                    {
                        RemoveCard(m_cards[i]);
                    }
                }
            }
            CommitChanges();
        }

        public UsersCardInfo[] GetRawSpaces()
        {
            lock (m_lock)
            {
                return m_cards.Clone() as UsersCardInfo[];
            }
        }

        public bool SuitCardEquip(int minSlot, int maxSlot, int templateId)
        {
            if (FindPlaceByTamplateId(minSlot, maxSlot, templateId) == 0 || FindPlaceByTamplateId(minSlot, maxSlot, templateId) == 1 || FindPlaceByTamplateId(minSlot, maxSlot, templateId) == 2 ||
                FindPlaceByTamplateId(minSlot, maxSlot, templateId) == 3 || FindPlaceByTamplateId(minSlot, maxSlot, templateId) == 4)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public int MissionEquipCard()
        {
            int Total = 0;
            UsersCardInfo CardAt0 = GetItemAt(0);//Ô 1
            UsersCardInfo CardAt1 = GetItemAt(1);//Ô 2
            UsersCardInfo CardAt2 = GetItemAt(2);//Ô 3
            UsersCardInfo CardAt3 = GetItemAt(3);//Ô 4
            UsersCardInfo CardAt4 = GetItemAt(4);//Ô 5
            if (CardAt0 != null)
            {
                if (CardAt0.Level >= 0 && CardAt0.Level < 10)
                {
                    Total += 1;
                }
                else if (CardAt0.Level >= 10 && CardAt0.Level < 20)
                {
                    Total += 1;
                }
                else if (CardAt0.Level >= 20 && CardAt0.Level < 30)
                {
                    Total += 1;
                }
                else if (CardAt0.Level == 30)
                {
                    Total += 1;
                }
            }
            if (CardAt1 != null)
            {
                if (CardAt1.Level >= 0 && CardAt1.Level < 10)
                {
                    Total += 1;
                }
                else if (CardAt1.Level >= 10 && CardAt1.Level < 20)
                {
                    Total += 1;
                }
                else if (CardAt1.Level >= 20 && CardAt1.Level < 30)
                {
                    Total += 1;
                }
                else if (CardAt1.Level == 30)
                {
                    Total += 1;
                }
            }
            if (CardAt2 != null)
            {
                if (CardAt2.Level >= 0 && CardAt2.Level < 10)
                {
                    Total += 1;
                }
                else if (CardAt2.Level >= 10 && CardAt2.Level < 20)
                {
                    Total += 1;
                }
                else if (CardAt2.Level >= 20 && CardAt2.Level < 30)
                {
                    Total += 1;
                }
                else if (CardAt2.Level == 30)
                {
                    Total += 1;
                }
            }
            if (CardAt3 != null)
            {
                if (CardAt3.Level >= 0 && CardAt3.Level < 10)
                {
                    Total += 1;
                }
                else if (CardAt3.Level >= 10 && CardAt3.Level < 20)
                {
                    Total += 1;
                }
                else if (CardAt3.Level >= 20 && CardAt3.Level < 30)
                {
                    Total += 1;
                }
                else if (CardAt3.Level == 30)
                {
                    Total += 1;
                }
            }
            if (CardAt4 != null)
            {
                if (CardAt4.Level >= 0 && CardAt4.Level < 10)
                {
                    Total += 1;
                }
                else if (CardAt4.Level >= 10 && CardAt4.Level < 20)
                {
                    Total += 1;
                }
                else if (CardAt4.Level >= 20 && CardAt4.Level < 30)
                {
                    Total += 1;
                }
                else if (CardAt4.Level == 30)
                {
                    Total += 1;
                }
            }
            return Total;
        }
    }
}
