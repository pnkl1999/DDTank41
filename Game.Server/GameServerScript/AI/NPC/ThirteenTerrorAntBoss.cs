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
    public class ThirteenTerrorAntBoss : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private int m_friendBoss = 13302;

        private string[] GlobalAttackChat = new string[] {
                    "Hãy liếm thử mũi tên này của ta",
                    "Xem có thốn không nhé",
                    "Ta sẽ hạ sát hết lũ các ngươi",
                    "Các ngươi nghĩ đủ trình hạ ta?."
                };

        private string[] FrozenAttackChat = new string[] {
                    "Băng trâm tiễn.",
                    "Liếm thử băng trâm tiễn của ta",
                    "Để ta giúp ngươi về trời nhanh."
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

            if(phyObjects.Count > 0)
            {
                foreach(PhysicalObj phy in phyObjects)
                {
                    Game.RemovePhysicalObj(phy, true);
                }
                phyObjects.Clear();
            }
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
                    GlobalAttack();
                    break;

                case 1:
                    FrozenAttack();
                    break;

                case 2:
                    PersonAttack();
                    m_attackTurn = -1;
                    break;

            }
            m_attackTurn++;
        }

        private void PersonAttack()
        {
            Body.CurrentDamagePlus = 1.3f;

            m_targer = Game.FindRandomPlayer();

            if (Body.ShootPoint(m_targer.X, m_targer.Y, 51, 1000, 10000, 1, 3.0f, 2800))
            {
                Body.PlayMovie("beatD", 1000, 3000);
            }
        }

        private void FrozenAttack()
        {
            int index = Game.Random.Next(0, FrozenAttackChat.Length);
            Body.Say(FrozenAttackChat[index], 0, 1000, 0);

            Player[] listAttack = Game.FindRandomPlayer(2);

            if(listAttack.Length > 0)
            {
                if (Body.ShootPoint(listAttack[0].X - 20, listAttack[0].Y, 99, 1000, 10000, 1, 3.0f, 3000))
                {
                    Body.PlayMovie("beatD", 1500, 3000);
                }
                
                if(listAttack.Length == 2)
                {
                    if (Body.ShootPoint(listAttack[1].X - 20, listAttack[1].Y, 99, 1000, 10000, 1, 3.0f, 5000))
                    {
                        Body.PlayMovie("beatD", 3500, 3000);
                    }
                }
            }
            
        }
        
        private void GlobalAttack()
        {
            Body.CurrentDamagePlus = 1.5f;
            int index = Game.Random.Next(0, GlobalAttackChat.Length);

            Body.Say(GlobalAttackChat[index], 0, 1000, 6000);

            Body.PlayMovie("beatC", 1500, 0);

            m_targer = Game.FindRandomPlayer();
            (Game as PVEGame).SendObjectFocus(m_targer, 0, 3000, 0);

            Body.CallFuction(CreateEffectGlobalAttack, 4000);
        }

        private void CreateEffectGlobalAttack()
        {
            foreach(Player p in Game.GetAllLivingPlayers())
            {
                phyObjects.Add(((PVEGame)Game).Createlayer(p.X, p.Y, "", "asset.game.ten.jianyu", "", 1, 1));

                Body.BeatDirect(p, "", 2000, 3, 1);
            }
            
        }

        private void DirectKill(List<Player> players)
        {
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatB", 1000, 0);
            foreach (Player p in players)
            {
                Body.BeatDirect(p, "", 2500, 1, 1);
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
