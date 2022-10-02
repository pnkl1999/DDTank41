﻿using Game.Server.GameUtils;

namespace Game.Server.Achievement
{
    public class MissionEquipCardBGWCCondition : BaseUserRecord
    {
        public MissionEquipCardBGWCCondition(GamePlayer player, int type)
: base(player, type)
        {
            switch (type)
            {

            }
            AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
            player.EquipCardEvent += Player_EquipCardEvent;
        }

        private void Player_EquipCardEvent()
        {
            CardInventory cardbag = m_player.CardBag;
            bool kq = false;
            int Para2 = 0;
            int Total = cardbag.MissionEquipCard();

            if (cardbag.SuitCardEquip(0, 4, 314107) && cardbag.SuitCardEquip(0, 4, 314106) && cardbag.SuitCardEquip(0, 4, 314105) && cardbag.SuitCardEquip(0, 4, 314104))
            {
                kq = true;
            }
            else
            {
                kq = false;
            }
            if (kq)
            {
                if (Total == 3)
                {
                    Para2 = 1;
                }
                else if (Total == 6)
                {
                    Para2 = 2;
                }
                else if (Total == 9)
                {
                    Para2 = 3;
                }
                else if (Total == 12)
                {
                    Para2 = 4;
                }
                else
                {
                    return;
                }
                m_player.AchievementInventory.UpdateUserAchievement(m_type, Para2, 1);
            }
        }

        public override void RemoveTrigger(GamePlayer player)
        {
            player.EquipCardEvent -= Player_EquipCardEvent;
        }
    }
}
