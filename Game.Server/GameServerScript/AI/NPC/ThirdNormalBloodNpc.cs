using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdNormalBloodNpc : ABrain//Vatto
    {
        private int m_blood = 1000;
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            AddBlood();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void AddBlood()
        {
            List<Living> lists = Game.FindAllTurnBossLiving();
            foreach(Living lv in lists)
            {
                if(lv.IsLiving)
                    lv.AddBlood(m_blood);
            }
        }
    }
}
