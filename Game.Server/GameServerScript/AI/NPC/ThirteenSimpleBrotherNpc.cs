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
    public class ThirteenSimpleBrotherNpc : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        private PhysicalObj phyObjects;

        private int m_friendBoss = 13005;

        private int m_damageBuff = 80;

        private int m_guardBuff = 25;

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
            Body.Properties1 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            if ((int)Body.Properties1 == 0)
            {
                CreateJitan();
            }
            else
            {
                FinishJitan();
            }

        }

        private void FinishJitan()
        {
            Body.Properties1 = 0;
            Body.Say("Tà thần vĩ đại, hãy ban sức mạnh của ngài cho chúng tôi!", 1, 1000);
            Body.PlayMovie("walk", 2000, 0);
            Body.BoltMove(1660, 485, 2500);

            List<Player> playerOnTop = new List<Player>();
            // check player have in it?
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving && p.X >= 1003 && p.X <= 1300 && p.Y <= 620)
                    playerOnTop.Add(p);
            }

            if (playerOnTop.Count > 0)
            {
                // co nguoi choi phia tren top => khong the cung te
                Body.CurrentDamagePlus = 2f;
                Body.PlayMovie("castA", 4000, 0);
                phyObjects.PlayMovie("beatA", 5000, 0);
                foreach (Player p in Game.GetAllLivingPlayers())
                {
                    if (p.IsLiving && playerOnTop.Contains(p))
                    {
                        // nguoi choi nam phia tren
                        Body.BeatDirect(p, "", 7500, 1, 1);
                    }

                    p.AddEffect(new AddDamageTurnEffect(m_damageBuff, 2), 7000);
                    p.AddEffect(new AddGuardTurnEffect(m_guardBuff, 2), 7000);
                }
                (Game as PVEGame).SendObjectFocus(m_friendNpc, 0, 9000, 0);
                m_friendNpc.Say("Có chuyện gì vậy? Cúng tế bị sai cmnr.", 0, 10500, 2000);

                Body.PlayMovie("walk", 8000, 0);
                Body.BoltMove(1604, 594, 8500);

                Body.CallFuction(RemovePhy, 13000);
            }
            else
            {
                // khong co nguoi choi trong vi tri can thiet lap => buff boss
                Body.PlayMovie("beatB", 4000, 0);

                Body.CallFuction(RemovePhy, 11000);

                m_friendNpc.Properties1 = 1;

                Body.PlayMovie("walk", 12000, 0);
                Body.BoltMove(1604, 594, 12500);
            }

            m_friendNpc.Delay = Game.GetLowDelayTurn() - 1;

            (Body as SimpleBoss).Delay = Game.GetHighDelayTurn() + 1;
        }

        private void RemovePhy()
        {
            Game.RemovePhysicalObj(phyObjects, true);
        }

        private void CreateJitan()
        {
            Body.Properties1 = 1;

            Body.Say("Lễ cúng tế sắp bắt đầu! Chúng ta sẽ có sức mạnh của tà thần! Hãy cố lên….", 1, 1000);

            Body.PlayMovie("call", 1100, 4000);

            Body.CallFuction(CreateJitanObject, 3000);
        }

        private void CreateJitanObject()
        {
            phyObjects = (Game as PVEGame).Createlayer(1150, 572, "front", "asset.game.ten.jitan", "1", 1, 0);
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