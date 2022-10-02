using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FiveHardSecondBoss : ABrain
    {
        private int m_attackTurn = 0;

        protected Player m_targer;

        private SimpleBoss m_leftNpc;

        private SimpleBoss m_rightNpc;

        private SimpleNpc m_bottomNpc;

        private SimpleNpc m_centerNpc;

        private List<PhysicalObj> effectPhys = new List<PhysicalObj>();

        private bool StepCenter = true;

        private int npcLeftId = 5212;

        private int npcRightId = 5213;

        private int npcBottomId = 5216;

        private int npcCenterId = 5217;

        private int m_bloodBuff = 10000;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
            if (m_leftNpc == null || m_rightNpc == null)
            {
                List<Living> listNps = Game.FindAllTurnBossLiving();
                foreach (Living npc in listNps)
                {
                    if (((SimpleBoss)npc).NpcInfo.ID == npcLeftId)
                        m_leftNpc = npc as SimpleBoss;
                    else if (((SimpleBoss)npc).NpcInfo.ID == npcRightId)
                        m_rightNpc = npc as SimpleBoss;
                }
            }

            if (m_bottomNpc == null || m_centerNpc == null)
            {
                foreach (SimpleNpc npc in Game.FindAllNpc())
                {
                    if (npc.NpcInfo.ID == npcBottomId)
                        m_bottomNpc = npc;
                    else if (npc.NpcInfo.ID == npcCenterId)
                        m_centerNpc = npc;
                }

                m_bottomNpc.Properties1 = 0;
                m_centerNpc.Properties1 = 0;
            }

            if (effectPhys.Count > 0)
            {
                foreach (PhysicalObj obj in effectPhys)
                {
                    Game.RemovePhysicalObj(obj, true);
                }
                effectPhys = new List<PhysicalObj>();
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
            StepCenter = true;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            // search player
            bool isKill = false;
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.X > 1138)
                {
                    isKill = true;
                    break;
                }
            }
            if (isKill)
            {
                KillAttack();
                return;
            }
            m_attackTurn++;
            switch (m_attackTurn)
            {
                case 1:
                    // left attack
                    if (m_leftNpc.IsLiving)
                        BeatFromLeft();
                    else
                        PersonAttack(null);
                    break;
                case 2:
                    // right attack
                    LivingCallBack callBack = null;
                    if (StepCenter)
                        callBack = CenterReadyShoot;
                    else
                        callBack = BottomReadyShoot;

                    if (m_rightNpc.IsLiving)
                        BeatFromRight(callBack);
                    else
                        PersonAttack(callBack);
                    break;
                case 3:
                    // center attack
                    if (StepCenter)
                    {
                        StepCenter = false;
                        CenterShoot();
                    }
                    else
                    {
                        StepCenter = true;
                        BottomShoot();
                    }
                    m_attackTurn = 0;
                    break;
            }
        }

        private void KillAttack()
        {
            Body.PlayMovie("beatA", 1000, 0);
            Body.RangeAttacking(1138, 2000, "cry", 4000, true);
        }

        private void PersonAttack(LivingCallBack callBack)
        {
            m_targer = Game.FindRandomPlayer();
            Body.PlayMovie("beatA", 1000, 0);
            Body.CallFuction(new LivingCallBack(CreateEffectPersonTarget), 3600);
            Body.BeatDirect(m_targer, "", 4000, 1, 1);
            if (callBack != null)
                Body.CallFuction(callBack, 5000);
        }

        private void BeatFromLeft()
        {
            Body.PlayMovie("beatD", 1000, 0);
            m_leftNpc.PlayMovie("failB", 1900, 0);
            m_leftNpc.PlayMovie("beatA", 3000, 4500);
            ((PVEGame)Game).SendFreeFocus(618, 585, 1, 5000, 0);
            m_leftNpc.CallFuction(new LivingCallBack(CreateEffectBeatLeft), 5800);
            m_leftNpc.RangeAttacking(m_leftNpc.X - 10000, m_leftNpc.X + 10000, "cry", 6300, null);
        }

        private void BeatFromRight(LivingCallBack callBack)
        {
            m_targer = Game.FindRandomPlayer();

            if (m_targer != null)
            {
                Body.PlayMovie("beatC", 1000, 0);
                Body.CallFuction(new LivingCallBack(AddBloodToAll), 4000);
                if (m_rightNpc.ShootPoint(m_targer.X - 15, m_targer.Y - 15, 56, 1000, 10000, 1, 2.5f, 6200))
                {
                    m_rightNpc.PlayMovie("beatA", 3500, 0);
                }
                if (callBack != null)
                    Body.CallFuction(callBack, 10000);
            }
        }

        private void BottomReadyShoot()
        {
            m_bottomNpc.Properties1 = 1;
            ((PVEGame)Game).SendObjectFocus(m_bottomNpc, 1, 1000, 0);
            m_bottomNpc.PlayMovie("toA", 2000, 3000);
            ChangeStateBottom();
        }

        private void BottomShoot()
        {
            m_bottomNpc.Properties1 = 0;
            m_bottomNpc.CurrentDamagePlus = 5f;
            ((PVEGame)Game).SendObjectFocus(Body, 1, 1000, 0);
            Body.PlayMovie("beatC", 2000, 0);
            ((PVEGame)Game).SendObjectFocus(m_bottomNpc, 1, 5000, 0);
            m_bottomNpc.PlayMovie("beatA", 6000, 5000);
            // get list can damage
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.Y > 760)
                {
                    m_bottomNpc.BeatDirect(p, "", 8000, 1, 1);
                }
            }
            ChangeStateBottom();
        }

        private void CenterReadyShoot()
        {
            m_centerNpc.Properties1 = 1;
            m_bottomNpc.CurrentDamagePlus = 2f;
            ((PVEGame)Game).SendObjectFocus(m_centerNpc, 1, 1000, 0);
            m_centerNpc.PlayMovie("toA", 2000, 3000);
        }

        private void CenterShoot()
        {
            m_centerNpc.Properties1 = 0;
            ((PVEGame)Game).SendObjectFocus(Body, 1, 1000, 0);
            Body.PlayMovie("beatB", 2000, 0);
            m_centerNpc.PlayMovie("beatA", 5000, 6000);
            // 4000
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if ((p.X <= 166 && p.Y <= 760) || (p.X >= 342 && p.X <= 637 && p.Y <= 760) || (p.X >= 820 && p.X <= 1116 && p.Y <= 760) || (p.X > 166 && p.X < 342 && p.Y > 760) || (p.X > 637 && p.X < 820 && p.Y > 760))
                    m_centerNpc.BeatDirect(p, "", 11000, 1, 1);
            }
        }

        private void ChangeStateBottom()
        {
            if ((int)m_bottomNpc.Properties1 == 1)
                ((PVEGame)Game).SendLivingActionMapping(m_bottomNpc, "stand", "standA");
            else
                ((PVEGame)Game).SendLivingActionMapping(m_bottomNpc, "stand", "stand");
        }

        private void CreateEffectBeatLeft()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                effectPhys.Add(((PVEGame)Game).Createlayer(p.X, p.Y, "", "asset.game.4.xiaopao", "", 1, 1));
            }
        }

        private void CreateEffectPersonTarget()
        {
            if (m_targer != null)
            {
                effectPhys.Add(((PVEGame)Game).Createlayer(m_targer.X, m_targer.Y, "", "asset.game.4.jinqudan", "", 1, 1));
            }
        }

        private void AddBloodToAll()
        {
            Body.AddBlood(m_bloodBuff);
            m_leftNpc.AddBlood(m_bloodBuff);
            m_rightNpc.AddBlood(m_bloodBuff);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
