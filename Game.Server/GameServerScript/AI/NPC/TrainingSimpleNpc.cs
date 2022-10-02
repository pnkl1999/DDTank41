using System;
using System.Collections.Generic;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Bussiness;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TrainingSimpleNpc : SimpleNpcAi
    {
        public override void OnStartAttacking()
        {
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
            m_targer = Game.FindNearestPlayer(Body.X, Body.Y);
            if (m_targer != null)
            {
                if (m_targer.Blood > 200)
                {
                    base.Beating();
                }
                else
                {
                    Beat();
                }
            }
        }
        public void BeatCallBack()
        {
            int currentBlood = m_targer.Blood;
            int demageAmount = currentBlood / 10;
            Body.Beat(m_targer, "beat", demageAmount, 0,0,1,1);
        }
        private void Beat()
        {
            int currentBlood = m_targer.Blood;
            int demageAmount = currentBlood / 10;
            
            if (m_targer != null && Body.Beat(m_targer, "beat", demageAmount,0,0,1,1) == false)
            {
                int dis = Game.Random.Next(80, 150);
                if (Body.X - m_targer.X > dis)
                {
                    Body.MoveTo(Body.X - dis, m_targer.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(BeatCallBack));
                }
                else
                {
                    Body.MoveTo(Body.X + dis, m_targer.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(BeatCallBack));
                }
            }
        }
    }
}
