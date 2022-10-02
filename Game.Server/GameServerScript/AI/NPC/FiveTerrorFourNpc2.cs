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
    public class FiveTerrorFourNpc2 : ABrain
    {
        private int m_attackTurn = 0;

        protected Player m_targer;

        private int m_bossId = 0;

        private int m_npcId = 0;

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
        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.Properties1 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnAfterTakedFrozen()
        {
            Body.Properties1 = (int)Body.Properties1 + 1;
            SetStand();
            switch ((int)Body.Properties1)
            {
                case 1:
                    Body.PlayMovie("standB", 100, 2000);
                    break;
                case 2:
                    Body.PlayMovie("standC", 100, 2000);
                    break;
            }
        }

        private void SetStand()
        {
            switch ((int)Body.Properties1)
            {
                case 0:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "stand");
                    break;
                case 1:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
                    break;
                case 2:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standC");
                    break;
            }
        }
    }
}
