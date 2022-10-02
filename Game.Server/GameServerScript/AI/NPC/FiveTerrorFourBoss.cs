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
    public class FiveTerrorFourBoss : ABrain
    {
        private int m_attackTurn = 0;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private int NextBloodChange = 0;

        protected Player m_targer;

        private int m_enemy2Id = 5334;

        private int m_npcId = 5332;

        private int m_plusBloodChange = 10;

        private static string[] AttackChat = new string[] {
                    ""
                };
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            foreach (PhysicalObj phy in phyObjects)
            {
                Game.RemovePhysicalObj(phy, true);
            }

            phyObjects = new List<PhysicalObj>();

            if ((int)Body.Properties2 == 3)
            {
                NextBloodChange = Body.Blood - (Body.MaxBlood / 100 * m_plusBloodChange);

                if (NextBloodChange < 0)
                    NextBloodChange = 0;

                Body.Properties2 = 0;
            }
            SetState();
        }

        private void SetState()
        {
            if ((int)Body.Properties2 == 1)
            {
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
                ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryB");
                Body.SetRect(-120, -190, 260, 200);
                Body.SetRelateDemagemRect(-120, -190, 260, 200);
            }
            else
            {
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standA");
                ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryA");
                Body.SetRect(-180, -90, 300, 100);
                Body.SetRelateDemagemRect(-60, -200, 116, 100);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
            NextBloodChange = Body.MaxBlood - (Body.MaxBlood / 100 * m_plusBloodChange);
            Body.Properties1 = 0;
            Body.Properties2 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            bool canKill = false;
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving && p.X >= 1580 || p.X <= 470)
                {
                    canKill = true;
                    return;
                }
            }

            if (canKill)
            {
                KillAttack();
                return;
            }

            if ((int)Body.Properties1 == 1)
            {
                AttackBeatA();
                Body.Properties1 = 0;
                return;
            }

            m_attackTurn++;
            switch (m_attackTurn)
            {
                case 1:
                    AttackBeatE();
                    break;

                case 2:
                    StartBeatA();
                    Body.Properties1 = 1;
                    break;

                case 3:
                    AttackBeatC();
                    break;

                case 4:
                    AttackBeatD();
                    m_attackTurn = 0;
                    break;
            }
        }

        private void KillAttack()
        {
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatC", 1000, 0);
            Body.RangeAttacking(1580, 2000, "cry", 3000, true);
        }

        private void StartBeatA()
        {
            Body.PlayMovie("beatA", 1000, 4000);
            Body.Properties1 = 1;
        }

        private void AttackBeatA()
        {
            bool canGlobalAttack = true;
            Body.CurrentDamagePlus = 10f;
            // check have npc or not
            SimpleNpc[] allNpcs = ((PVEGame)Game).GetNPCLivingWithID(m_enemy2Id);
            if (allNpcs.Length > 0)
            {
                // check can damage
                if ((int)allNpcs[0].Properties1 == 2)
                    canGlobalAttack = false;
            }

            if (canGlobalAttack)
            {
                Body.PlayMovie("beatF", 1000, 5000);
                Body.RangeAttacking(480, 1580, "cry", 4000, true);
            }
            else
            {
                Body.PlayMovie("beatB", 1000, 0);
                Body.RangeAttacking(1330, 2000, "cry", 4000, true);
            }

            //play remove all npc
            foreach (SimpleNpc npc in allNpcs)
            {
                switch ((int)npc.Properties1)
                {
                    case 0:
                        npc.PlayMovie("die", 3500, 0);
                        break;
                    case 1:
                        npc.PlayMovie("dieB", 3500, 0);
                        break;
                    case 2:
                        npc.PlayMovie("dieC", 3500, 0);
                        break;
                }
                npc.Die(5000);
            }
        }

        private void AttackBeatC()
        {
            m_targer = Game.FindRandomPlayer();

            if (m_targer != null)
            {
                Body.PlayMovie("beatC", 1000, 0);
                ((PVEGame)Game).SendObjectFocus(m_targer, 1, 2800, 0);
                Body.CallFuction(new LivingCallBack(CreateBeatCEffect), 3500);
                Body.RangeAttacking(m_targer.X - 50, m_targer.X + 50, "cry", 4000, true);
            }
        }

        private void AttackBeatD()
        {
            Body.CurrentDamagePlus = 1.5f;
            Body.PlayMovie("beatD", 1000, 0);
            Body.CallFuction(new LivingCallBack(CreateBeatDEffect), 1500);
            Body.CallFuction(new LivingCallBack(SetDefaultSpeedMult), 5000);
        }

        private void AttackBeatE()
        {
            Body.CurrentDamagePlus = 2f;
            Body.PlayMovie("beatE", 1000, 5000);
            Body.RangeAttacking(480, 1580, "cry", 4000, true);
        }

        private void CreateBeatDEffect()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                phyObjects.Add(((PVEGame)Game).CreatePhysicalObj(0, 0, "top", "asset.game.4.cuipao", "", 1, 1, p.Id + 1));
                p.SpeedMultX(18);
                p.StartSpeedMult(p.X - 400, p.Y, 0);
                Body.BeatDirect(p, "", 100, 3, 1);
            }
        }

        private void SetDefaultSpeedMult()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                p.SpeedMultX(3);
            }
        }

        private void CreateBeatCEffect()
        {
            phyObjects.Add(((PVEGame)Game).Createlayer(m_targer.X, m_targer.Y, "", "asset.game.4.guang", "", 1, 1));
        }

        private void CallNpc()
        {
            LivingConfig config = ((PVEGame)Game).BaseConfig();
            config.IsFly = true;

            int randX = Game.Random.Next(570, 647);

            ((SimpleBoss)Body).CreateChild(m_npcId, randX, 550, true, config);
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnAfterTakedBomb()
        {
            if (Body.Blood <= NextBloodChange && (int)Body.Properties2 == 0 && Body.IsLiving)
            {
                Body.Properties2 = 1;
                Body.BlockTurn = true;
                Body.PlayMovie("AtoB", 100, 1100);
                SetState();
                Body.CallFuction(CallNpc, 1200);
            }
        }

    }
}
