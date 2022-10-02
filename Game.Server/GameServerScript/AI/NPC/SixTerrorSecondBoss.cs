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
    public class SixTerrorSecondBoss : ABrain
    {
        private int m_redNpc = 6321;

        private int m_blueNpc = 6322;

        private SimpleNpc[] m_blue;

        private SimpleNpc[] m_red;

        private int m_bloodBuff = 5000;

        private List<PhysicalObj> m_phy = new List<PhysicalObj>();

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

            if (m_blue == null || m_red == null)
            {
                m_blue = Game.GetNPCLivingWithID(m_blueNpc);
                m_red = Game.GetNPCLivingWithID(m_redNpc);
            }


            // check have deadbody
            foreach (SimpleNpc npc in m_blue)
            {
                if (npc.Blood <= 1)
                {
                    Body.PlayMovie("beat", 1000, 0);
                    (Game as PVEGame).SendFreeFocus(1100, 650, 1, 2500, 3000);
                    Body.CallFuction(RestoreBloodNpcEffect, 3500);
                    return;
                }
            }

            // damage red team
            Body.CurrentDamagePlus = 1.5f;
            Body.PlayMovie("beatA", 1000, 0);
            (Game as PVEGame).SendFreeFocus(1100, 650, 1, 2500, 3000);
            Body.CallFuction(DamageNpcEffect, 3500);

        }

        private void DamageNpcEffect()
        {
            foreach (SimpleNpc npc in m_red)
            {
                if (!npc.Config.CompleteStep)
                    m_phy.Add((Game as PVEGame).Createlayer(npc.X, npc.Y, "front", "asset.game.six.qunti", "", 1, 0));
            }

            Body.CallFuction(DamageNpcBuff, 500);
        }

        private void DamageNpcBuff()
        {
            foreach (SimpleNpc npc in m_red)
            {
                if (!npc.Config.CompleteStep)
                    Body.BeatDirect(npc, "", 100, 1, 1);
            }
        }

        private void RestoreBloodNpcEffect()
        {
            foreach (SimpleNpc npc in m_blue)
            {
                if (!npc.Config.CompleteStep)
                    m_phy.Add((Game as PVEGame).Createlayer(npc.X, npc.Y, "front", "asset.game.six.qunjia", "", 1, 0));
            }

            Body.CallFuction(RestoreBloodNpcBuff, 500);
        }

        private void RestoreBloodNpcBuff()
        {
            foreach (SimpleNpc npc in m_blue)
            {
                if (!npc.Config.CompleteStep)
                    npc.AddBlood(m_bloodBuff);
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
