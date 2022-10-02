using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleBloomNpc : ABrain
    {
        private Player m_target = null;
		
		private int m_maxBlood;
        
		private int m_blood;
		
		private int living;
		
		private int m_team;
		
		private int Team;

        private int m_targetDis = 0;
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
            m_target = Game.FindNearestPlayer(Body.X, Body.Y);
			m_maxBlood = 49999;
            m_blood = 40000;
			Body.Say(LanguageMgr.GetTranslation("Hồi máu cho tôi, tôi sẻ dẫn các cậu ra khỏi đây !"), 0, 200, 0);
			if (m_blood > m_maxBlood)
            {
                m_blood = m_maxBlood;
				Body.PlayMovie("grow", 100, 0); 	
			    Body.Die(1000);
			}	
			else
            {
                Beat();
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void MoveToPlayer(Player player)
        {
            int dis = Game.Random.Next(((SimpleNpc)Body).NpcInfo.MoveMin, ((SimpleNpc)Body).NpcInfo.MoveMax);
            if (player.X > Body.X)
            {
                Body.MoveTo(Body.X + dis, Body.Y, "walk", 2000, "", 3, new LivingCallBack(Beat));
            }
            else
            {
                Body.MoveTo(Body.X - dis, Body.Y, "walk", 2000, "", 3, new LivingCallBack(Beat));
            }
        }

        public void Beat()
        {
            //Body.AddBlood(2197);
        }
    }
}
