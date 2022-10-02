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
using Game.Server.GameServerScript.AI.Messions;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FourHardBlowArmsNpc : ABrain
    {
        private int m_attackTurn = 0;

        private PhysicalObj m_moive = null;

        SimpleNpc npcDamage = null;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
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

            Point nextPoint = new Point();

            switch (m_attackTurn)
            {
                case 0:
                    nextPoint = new Point(672, 746);
                    break;
                case 1:
                    nextPoint = new Point(1059, 749);
                    break;
                case 2:
                    nextPoint = new Point(1412, 751);
                    break;
            }

            int mindis = int.MaxValue;

            foreach (SimpleNpc npc in Game.FindAllNpcLiving())
            {
                if (npc.IsLiving && npc.X >= Body.X && npc.X <= Body.X + nextPoint.X)
                {
                    int dis = (int)Body.Distance(npc.X, npc.Y);
                    if (dis < mindis)
                    {
                        npcDamage = npc;
                        mindis = dis;
                    }
                }
            }

            if (npcDamage != null)
            {
                MoveToPlace(npcDamage.X - 20, npcDamage.Y, BeatNpc);
            }
            else
            {
                if (m_attackTurn < 2)
                {
                    MoveToPlace(nextPoint.X, nextPoint.Y, null);
                }
                else
                {
                    MoveToPlace(nextPoint.X, nextPoint.Y, StartBomber);
                    m_attackTurn = 0;
                }
            }
            m_attackTurn++;
        }

        private void MoveToPlace(int x, int y, LivingCallBack callBack)
        {
            Body.MoveTo(x, y, "walk", 1000, 5, callBack);
        }

        public void BeatNpc()
        {
            Body.Beat(npcDamage, "die", 5000, 5000, 800);
            Body.Die(3000);
        }

        private void StartBomber()
        {
            Body.PlayMovie("beatA", 2000, 6000);
            Body.CallFuction(new LivingCallBack(CreateCrashGate), 4500);
        }

        private void CreateCrashGate()
        {
            int typeGate = ((PVEGame)Game).MissionAI.UpdateUIData();
            switch (typeGate)
            {
                case 0:
                    if (m_moive == null)
                        m_moive = ((PVEGame)Game).Createlayer(1590, 750, "", "game.asset.Gate", "cryA", 1, 0);
                    else
                        m_moive.PlayMovie("cryA", 0, 0);
                    break;

                case 1:
                    if (m_moive == null)
                        m_moive = ((PVEGame)Game).Createlayer(1590, 750, "", "game.asset.Gate", "cryB", 1, 0);
                    else
                        m_moive.PlayMovie("cryB", 0, 0);
                    break;

                case 2:
                    if (m_moive == null)
                        m_moive = ((PVEGame)Game).Createlayer(1590, 750, "", "game.asset.Gate", "cryC", 1, 0);
                    else
                        m_moive.PlayMovie("cryC", 0, 0);
                    break;
            }

            (((PVEGame)Game).MissionAI as DCH4201).CountKill++;

            Body.Die();

        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
