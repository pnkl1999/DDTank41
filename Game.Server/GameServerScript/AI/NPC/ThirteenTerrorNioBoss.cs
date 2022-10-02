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
    public class ThirteenTerrorNioBoss : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private int m_friendBoss = 13301;

        private int m_healBloodSelf = 30000;

        private int m_healBloodFriend = 130000;
        
        private string[] HealChat = new string[] {
                    "Phê phê phê. Coi đánh ta kiểu gì?",
                    "Ôi thật thần kỳ. Buff máu phê vãi",
                    "Buff cho phê, phê như con tê tê..",
                    "Đánh bại ta đâu có dễ. Coi ta này."
                };
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
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            
            // check can kill player
            List<Player> pneedkill = new List<Player>();

            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving && p.X > 1066)
                    pneedkill.Add(p);
            }

            if (pneedkill.Count > 0)
            {
                DirectKill(pneedkill);
                return;
            }

            switch (m_attackTurn)
            {
                case 0:
                    BeatA();
                    break;

                case 1:
                    HealBlood();
                    break;

                case 2:
                    BeatFrozen();
                    m_attackTurn = -1;
                    break;

            }
            m_attackTurn++;
        }

        private void BeatFrozen()
        {
            List<Player> listKiller = new List<Player>();

            if(m_friendNpc.IsLiving)
            {
                // find and kill player
                foreach(Player p in Game.GetAllLivingPlayers())
                {
                    if (p.IsFrost)
                        listKiller.Add(p);
                }
            }

            Body.PlayMovie("beat", 1000, 0);

            if (listKiller.Count > 0)
            {
                Body.CurrentDamagePlus = 1000f;
                
                foreach(Player p in listKiller)
                {
                    Body.BeatDirect(p, "", 3200, 1, 1);
                }
            }
            else
            {
                Body.CurrentDamagePlus = 1.5f;
                Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 3200, false);
            }
        }

        private void BeatA()
        {
            Body.CurrentDamagePlus = 1.8f;

            m_targer = Game.FindRandomPlayer();

            Body.ChangeDirection(m_targer, 500);

            if (Body.ShootPoint(m_targer.X, m_targer.Y, 61, 1000, 10000, 1, 1.7f, 1900))
            {
                Body.PlayMovie("beat2", 1000, 4000);
            }
        }

        private void HealBlood()
        {
            int index = Game.Random.Next(0, HealChat.Length);
            Body.Say(HealChat[index], 0, 1000);

            Body.PlayMovie("renew", 1500, 3500);
            
            Body.CallFuction(HealBloodCallBack, 3000);
        }

        private void HealBloodCallBack()
        {
            Body.AddBlood(m_healBloodSelf);

            if(m_friendNpc.IsLiving)
            {
                (Game as PVEGame).SendObjectFocus(m_friendNpc, 0, 1500, 0);

                Body.CallFuction(HealFriendBlood, 3000);
            }
            
        }

        private void HealFriendBlood()
        {
            m_friendNpc.AddBlood(m_healBloodFriend);
        }

        private void DirectKill(List<Player> players)
        {
            Body.CurrentDamagePlus = 1000f;
            foreach (Player p in players)
            {
                Body.BeatDirect(p, "", 2000, 1, 1);
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
