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
    public class FourTerrorGunNpc : ABrain
    {
        private int m_attackTurn = 0;

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

            bool result = false;

            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > Body.X - 300 && player.X < Body.X + 300)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(Body.X - 300, Body.X + 300);
                return;
            }

            if (m_attackTurn == 0)
            {
                // chua mo mat
                Body.PlayMovie("beatA", 1000, 0);
                ((PVEGame)Game).SendFreeFocus(900, 698, 1, 2600, 0);
                Body.CallFuction(new LivingCallBack(SetStand), 3000);
                Body.Properties1 = 1;
                m_attackTurn++;
            }
            if (m_attackTurn == 1)
            {
                Body.PlayMovie("beatB", 1000, 0);

                ((PVEGame)Game).SendFreeFocus(900, 698, 2, 2500, 1000);

                Body.RangeAttacking(409, 1900, "cry", 4000, false, null);

                Body.CallFuction(new LivingCallBack(SetStand), 4000);
                Body.Properties1 = 0;
                m_attackTurn = 0;
            }
        }

        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatC", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 2000, null);
            Body.CallFuction(new LivingCallBack(SetStand), 2500);
        }

        private void SetStand()
        {
            switch ((int)Body.Properties1)
            {
                case 1:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
                    break;
                default:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "stand");
                    break;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
