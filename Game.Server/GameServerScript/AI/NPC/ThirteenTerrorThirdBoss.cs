using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirteenTerrorThirdBoss : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        private List<Player> m_listtarget;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private PhysicalObj phyBig1000;

        private PhysicalObj phyIronFire;

        private int m_friendBoss = 13306;

        private int m_guardDamage = 80;

        private int m_bloodHeal = 20000;

        private string[] Chat_CallFriendAttacking = { "Đè chết mọe nó đi cho ta.",
                                                       "Đè chết choa nó đi cho ta.",
                                                       "Hấp diêm nó cho ta.",
                                                       "Đè xịt shit bọn nó cho ta."
        };

        private string[] Chat_CallChoiceTarget = { "Ồ, đúng rồi đó. Chính là ngươi",
                                                    "Người tiếp theo sẽ là ngươi",
                                                    "Ngươi. Chính ngươi đấy!!"};

        private string[] Chat_CallFriendFucking = { "Mi bị cái gì thế?",
                                                    "Đồ ngu học chả được tích sự gì cả.",
                                                    "Ngươi muốn bị ta lột da hả?",
                                                    "Con cờ hó kia bóp zái ta hả?",
                                                    "Ngươi đang giúp bọn chúng hay giúp ta vậy?" };
        

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (m_friendNpc == null)
            {
                SimpleBoss[] npcs = ((PVEGame)Game).FindLivingTurnBossWithID(m_friendBoss);
                if (npcs.Length > 0)
                    m_friendNpc = npcs[0];
            }
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

        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.Properties1 = 0;
            Body.Config.CancelGuard = false;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            switch (m_attackTurn)
            {
                case 0:
                    // gau gau
                    FirstAttack();
                    break;

                case 1:
                    AttackToTarget();
                    break;

                case 2:
                    HealBloodOrWalkup();
                    break;

                case 3:
                    NextWalkAttack();
                    break;

                case 4:
                    m_attackTurn = -1;
                    break;

            }
            m_attackTurn++;
        }

        private void FirstAttack()
        {
            // check
            if((int)Body.Properties1 != 0)
            {
                HealBloodOrWalkup();
            }
            else
            {
                FindRandomTarget();
            }
        }

        private void NextWalkAttack()
        {
            Body.CurrentDamagePlus = 1.8f;

            if(m_targer != null)
            {
                m_listtarget = new List<Player>();
                // run pass to client
                Body.ChangeDirection(m_targer, 1000);

                if(Body.FindDirection(m_targer) == 1)
                {
                    // chay ve phia ben phai man hinh
                    foreach (Player p in Game.GetAllLivingPlayers())
                    {
                        if (p.X >= Body.X && p.X <= Game.Map.Bound.Width)
                        {
                            m_listtarget.Add(p);
                        }
                    }
                    Body.MoveTo(Game.Map.Bound.Width, Body.Y, "walk", 2000, 10, CallDamageListPlayers);
                    
                }
                else
                {
                    // chay ve phia ben trai man hinh
                    foreach (Player p in Game.GetAllLivingPlayers())
                    {
                        if (p.X >= 0 && p.X <= Body.X)
                        {
                            m_listtarget.Add(p);
                        }
                    }
                    Body.MoveTo(0, Body.Y, "walk", 2000, 10, CallDamageListPlayers);
                }
                
            }
        }

        private void CallDamageListPlayers()
        {
            if(m_listtarget.Count > 0)
            {
                foreach(Player p in m_listtarget)
                {
                    Body.BeatDirect(p, "", 1000, 1, 1);
                }
            }

            // find box
            SimpleNpc[] npcs = Game.FindAllNpcLiving();
            if(npcs.Length > 0)
            {
                foreach(SimpleNpc npc in npcs)
                {
                    if(npc.Properties1 != null)
                    {
                        // show player and take damage
                        Player p = Game.FindPlayer((int)npc.Properties1);

                        if(p != null && p.IsLiving)
                        {
                            p.SetVisible(true);
                            p.BlockTurn = false;
                        }
                    }
                    npc.PlayMovie("die", 500, 0);
                    npc.Die(2000);
                }
            }
            Body.CallFuction(RandomJumpBack, 2500);
        }

        private void RandomJumpBack()
        {
            int randX = Game.Random.Next(100, Game.Map.Bound.Width - 100);

            Body.PlayMovie("jump", 1000, 0);

            Body.BoltMove(randX, Body.Y, 3000);

            (Game as PVEGame).SendFreeFocus(randX, Body.Y, 1, 2000, 0);

            Body.PlayMovie("fall", 3000, 2000);
        }

        private void HealBloodOrWalkup()
        {
            if((int)Body.Properties1 == 0)
            {
                // khong bi attack => heal blood
                Body.PlayMovie("beatA", 1000, 4000);
                Body.CallFuction(HealBlood, 3000);
            }
            else
            {
                (Game as PVEGame).SendLivingActionMapping(Body, "stand", "stand");
                (Game as PVEGame).SendLivingActionMapping(Body, "cry", "cry");
                Body.Properties1 = 0;
                Body.Config.CancelGuard = false;

                Body.PlayMovie("stand", 500, 0);
                Body.ChangeDirection(m_friendNpc, 1000);
                int rand = Game.Random.Next(Chat_CallFriendFucking.Length);
                Body.Say(Chat_CallFriendFucking[rand], 2000, 3000);
            }

            Body.CallFuction(FindNextTarget, 5000);
        }
        

        private void FindNextTarget()
        {
            m_targer = Game.FindRandomPlayer();
            
            Body.ChangeDirection(m_targer, 500);

            int rand = Game.Random.Next(Chat_CallChoiceTarget.Length);
            Body.Say(Chat_CallChoiceTarget[rand], 1000, 0);

            Body.CallFuction(SetTargetPlayer, 2000);
            
        }

        private void HealBlood()
        {
            Body.AddBlood(m_bloodHeal);
        }

        private void AttackToTarget()
        {
            Body.CurrentDamagePlus = 2.5f;

            Body.ChangeDirection(m_targer, 1000);

            Body.PlayMovie("jump", 2000, 1600);

            Body.BoltMove(m_targer.X, m_targer.Y, 3700);

            Body.PlayMovie("fallB", 4000, 2000);

            Body.BeatDirect(m_targer, "", 5000, 1, 1);

            Body.CallFuction(RemoveEffectPlayer, 6000);

        }

        private void RemoveEffectPlayer()
        {
            // remove effect
            if(m_targer != null)
            {
                AddTargetEffect effect = m_targer.EffectList.GetOfType(eEffectType.AddTargetEffect) as AddTargetEffect;
                if (effect != null)
                {
                    effect.Stop();
                }
            }
            else
            {
                foreach(Player p in Game.GetAllLivingPlayers())
                {
                    AddTargetEffect effect = p.EffectList.GetOfType(eEffectType.AddTargetEffect) as AddTargetEffect;
                    if (effect != null)
                    {
                        effect.Stop();
                    }
                }
            }
            
        }

        private void FindRandomTarget()
        {
            m_targer = Game.FindRandomPlayer();
            int rand = Game.Random.Next(Chat_CallFriendAttacking.Length);
            Body.Say(Chat_CallFriendAttacking[rand], 1000, 0);

            Body.CallFuction(SetTargetPlayer, 3000);
        }

        private void SetTargetPlayer()
        {
            if(m_targer != null)
            {
                m_targer.AddEffect(new AddTargetEffect(), 0);
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
