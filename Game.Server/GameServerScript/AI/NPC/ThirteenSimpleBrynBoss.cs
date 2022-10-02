using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Game.Logic.Effects;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirteenSimpleBrynBoss : ABrain
    {
        private int m_attackTurn = 0;

        private int m_countNormalAttack = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private int m_friendBoss = 13004;

        private int m_fearLength = 30;

        private int m_healBlood = 5000;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (m_friendNpc == null)
            {
                SimpleBoss[] npcs = ((PVEGame)Game).FindLivingTurnBossWithID(m_friendBoss);
                if (npcs.Length > 0)
                    m_friendNpc = npcs[0];
            }
            m_countNormalAttack = 0;
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            if (phyObjects != null && phyObjects.Count > 0)
            {
                foreach (PhysicalObj phy in phyObjects)
                {
                    Game.RemovePhysicalObj(phy, true);
                }
                phyObjects.Clear();
            }

            if ((int)Body.Properties1 == 2)
            {
                (Game as PVEGame).SendPlayersPicture(Body, (int)BuffType.DamageEffect, false);
                (Game as PVEGame).SendPlayersPicture(Body, (int)BuffType.GuardEffect, false);
                Body.Properties1 = 0;
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.Properties1 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            // check can kill player
            List<Player> pneedkill = new List<Player>();

            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving && (Body.X - 150) <= p.X && (Body.X + 150) >= p.X && p.Y >= 780)
                {
                    pneedkill.Add(p);
                }
            }

            if (pneedkill.Count > 0)
            {
                DirectKill(pneedkill);
                return;
            }

            switch (m_attackTurn)
            {
                case 0:
                    FirstAttack();
                    break;

                case 1:
                    NextAttack();
                    break;

                case 2:
                    CallBuff();
                    break;

                case 3:
                    UseBuff();
                    break;

                case 4:
                    NormalAttack();
                    m_attackTurn = -1;
                    break;

            }
            m_attackTurn++;
        }

        private void NormalAttack()
        {
            m_friendNpc.Delay = Game.GetHighDelayTurn() + 1;

            m_targer = Game.FindRandomPlayer();

            if (m_targer != null && m_targer.IsLiving)
            {
                Body.ChangeDirection(m_targer, 1000);

                if (m_targer.Y > 620)
                {
                    // nam duoi

                    if (Body.ShootPoint(m_targer.X, m_targer.Y, 55, 1000, 10000, 1, 1.5f, 2900))
                    {
                        Body.PlayMovie("beatB", 2000, 3000);
                    }
                }
                else
                {
                    Body.CurrentDamagePlus = 15f;
                    Body.Say("Ngươi dám leo lên trên đó à? Chết đi!!!", 0, 2000);
                    Body.PlayMovie("beatC", 3000, 0);

                    Body.BeatDirect(m_targer, "", 4000, 3, 1);
                }
            }

            if (m_countNormalAttack == 0)
            {
                Body.CallFuction(NormalAttack, 4000);
            }

            m_countNormalAttack++;
        }

        private void UseBuff()
        {
            m_friendNpc.Delay = Game.GetHighDelayTurn() + 1;

            if ((int)Body.Properties1 == 1)
            {
                // buff effect
                Body.CurrentDamagePlus = 10f;
                Body.Say("Hãy xem sức mạnh của tà thần đây. Đây mới chính là sức mạnh thực sự của ta.", 1, 1000);
                (Game as PVEGame).SendPlayersPicture(Body, (int)BuffType.DamageEffect, true);
                (Game as PVEGame).SendPlayersPicture(Body, (int)BuffType.GuardEffect, true);
                Body.CallFuction(CallCompleteBuffEffect, 2000);
                Body.Properties1 = 2;
            }
            else
            {
                Body.CurrentDamagePlus = 2.3f;
                Body.Say("Đậu xanh rau muống dám phá nghi lễ của ta.", 1, 2000);
                Body.PlayMovie("beatC", 3000, 0);
                Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "", 4000, false);
            }
        }

        private void CallCompleteBuffEffect()
        {
            phyObjects.Add((Game as PVEGame).Createlayer(Body.X, Body.Y, "", "asset.game.ten.up", "", 1, 0));
            Body.PlayMovie("beatC", 2000, 5000);
            Body.CallFuction(CallHealBlood, 3000);
            Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "", 4000, false);
        }

        private void CallHealBlood()
        {
            Body.AddBlood(m_healBlood);
        }

        private void CallBuff()
        {
            Body.Say("Hãy mau thực hiện nghi thức cúng tế, sức mạnh tà thần sẽ thuộc về ta!", 1000, 3000);
            Body.Properties1 = 0;
            m_friendNpc.Delay = Game.GetLowDelayTurn() - 1;
        }

        private void NextAttack()
        {
            m_friendNpc.Delay = Game.GetHighDelayTurn() + 1;
            Body.PlayMovie("callA", 1000, 0);

            m_targer = Game.FindRandomPlayer();
            if (m_targer != null)
                (Game as PVEGame).SendObjectFocus(m_targer, 1, 2000, 0);

            Body.CallFuction(CallObjectNextAttack, 2800);

        }

        private void CallObjectNextAttack()
        {
            Body.CurrentDamagePlus = 1.8f;
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                int index = Game.Random.Next(0, 3);

                switch (index)
                {
                    case 0:
                        // lock
                        phyObjects.Add((Game as PVEGame).Createlayer(p.X, p.Y, "", "asset.game.ten.jiaodu", "", 1, 0));
                        p.AddEffect(new LockDirectionEffect(2), 1500);
                        break;

                    case 1:
                        // fear
                        phyObjects.Add((Game as PVEGame).Createlayer(p.X, p.Y, "", "asset.game.ten.pilao", "", 1, 0));
                        p.AddEffect(new ReduceStrengthEffect(2, m_fearLength), 1500);
                        break;

                    default:
                        phyObjects.Add((Game as PVEGame).Createlayer(p.X, p.Y, "", "asset.game.ten.pilao", "", 1, 0));
                        Body.BeatDirect(p, "", 1500, 1, 1);
                        break;
                }
                Body.BeatDirect(p, "", 1500, 1, 1);
            }
        }

        private void FirstAttack()
        {
            m_targer = Game.FindRandomPlayer();

            if (m_targer != null)
                (Game as PVEGame).SendObjectFocus(m_targer, 1, 2000, 0);
            Body.PlayMovie("callA", 1000, 0);
            Body.CallFuction(CreateFirstDamageEffect, 3000);
        }

        private void CreateFirstDamageEffect()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                phyObjects.Add((Game as PVEGame).Createlayer(p.X, p.Y, "", "asset.game.ten.baozha", "", 1, 0));
            }
            Body.CallFuction(MoveAllPlayerEffect, 1200);
        }

        private void MoveAllPlayerEffect()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving)
                {
                    p.SpeedMultX(20);

                    if (Body.FindDirection(p) == 1)
                    {
                        // phai
                        p.StartSpeedMult(p.X - Game.Random.Next(400, 600), p.Y, 0);
                    }
                    else
                    {
                        // trai
                        p.StartSpeedMult(p.X + Game.Random.Next(400, 600), p.Y, 0);
                    }
                }
                Body.BeatDirect(p, "", 1500, 1, 1);
            }

            Body.CallFuction(SetDefaultSpeedMult, 5000);
        }

        private void SetDefaultSpeedMult()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                p.SpeedMultX(3);
            }
        }

        private void DirectKill(List<Player> players)
        {
            Body.CurrentDamagePlus = 1000f;
            Body.Say("Chán sống hay sao mà đứng gần ta?", 1, 1000);
            Body.PlayMovie("beatC", 2000, 0);
            foreach (Player p in players)
            {
                Body.BeatDirect(p, "", 3500, 1, 1);
            }
        }


        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
