using Bussiness;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.GameUtils
{
    public class CardInventory : CardAbstractInventory
    {
        protected GamePlayer m_player;

        private bool bool_0;

        private List<UsersCardInfo> list_0;

        public GamePlayer Player => m_player;

        public CardInventory(GamePlayer player, bool saveTodb, int capibility, int beginSlot)
            : base(capibility, beginSlot)
        {
            list_0 = new List<UsersCardInfo>();
            m_player = player;
            bool_0 = saveTodb;
        }

        public virtual void LoadFromDatabase()
        {
            if (!bool_0)
            {
                return;
            }
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            UsersCardInfo[] singleUserCard = playerBussiness.GetSingleUserCard(m_player.PlayerCharacter.ID);
            BeginChanges();
            try
            {
                UsersCardInfo[] array = singleUserCard;
                UsersCardInfo[] array2 = array;
                foreach (UsersCardInfo usersCardInfo in array2)
                {
                    AddCardTo(usersCardInfo, usersCardInfo.Place);
                }
            }
            finally
            {
                CommitChanges();
            }
        }

        public virtual void SaveToDatabase()
        {
            if (!bool_0)
            {
                return;
            }
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            lock (m_lock)
            {
                for (int i = 0; i < m_cards.Length; i++)
                {
                    UsersCardInfo usersCardInfo = m_cards[i];
                    if (usersCardInfo?.IsDirty ?? false)
                    {
                        if (usersCardInfo.CardID > 0)
                        {
                            playerBussiness.UpdateCards(usersCardInfo);
                        }
                        else if (usersCardInfo.CardID == 0 && usersCardInfo.Place != -1)
                        {
                            playerBussiness.AddCards(usersCardInfo);
                        }
                    }
                }
            }
            lock (list_0)
            {
                foreach (UsersCardInfo item in list_0)
                {
                    if (item.CardID > 0)
                    {
                        playerBussiness.UpdateCards(item);
                    }
                }
                list_0.Clear();
            }
        }

        public virtual bool AddCard(int templateId, int count)
        {
            UsersCardInfo itemByTemplateID = GetItemByTemplateID(templateId);
            if (itemByTemplateID == null)
            {
                return AddCard(new UsersCardInfo(m_player.PlayerCharacter.ID, templateId, count));
            }
            itemByTemplateID.Count += count;
            UpdateCard(itemByTemplateID);
            return true;
        }

        public override bool AddCardTo(UsersCardInfo item, int place)
        {
            if (!base.AddCardTo(item, place))
            {
                return false;
            }
            item.UserID = m_player.PlayerCharacter.ID;
            return true;
        }

        public override bool RemoveCardAt(int place)
        {
            UsersCardInfo itemAt = GetItemAt(place);
            if (itemAt == null)
            {
                return false;
            }
            list_0.Add(itemAt);
            base.RemoveCardAt(place);
            return true;
        }

        public override bool RemoveCard(UsersCardInfo item)
        {
            if (item == null)
            {
                return false;
            }
            list_0.Add(item);
            base.RemoveCard(item);
            return true;
        }

        public override void UpdateChangedPlaces()
        {
            m_player.Out.SendUpdateCardData(this, m_changedPlaces.ToArray());
            base.UpdateChangedPlaces();
        }

        public bool IsCardEquip(int templateid)
        {
            foreach (UsersCardInfo item in GetEquipCard())
            {
                if (item.TemplateID == templateid)
                {
                    return true;
                }
            }
            return false;
        }

        public bool IsCardEquip(List<UsersCardInfo> info, int length)
        {
            //int output[];
            foreach (var item in GetCards(0, 4))
            {

            }
            return false;
        }
    }
}
