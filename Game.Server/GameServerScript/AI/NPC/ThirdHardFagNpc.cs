using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using Game.Logic;
using Game.Logic.Actions;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdHardFagNpc : ABrain
    {
        private int m_turn = 0;

        private int m_strengReduce = 100;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            m_turn++;
            if (m_turn >= 4)
                Body.Die();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
        }

        private void StopEffect()
        {
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
            {
                ReduceStrengthEffect effect = player.EffectList.GetOfType(eEffectType.ReduceStrengthEffect) as ReduceStrengthEffect;

                if (effect != null)
                    effect.Stop();
            }
        }
        public override void OnDie()
        {
            base.OnDie();
            StopEffect();
        }
        public override void OnCreated()
        {
            base.OnCreated();
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
            {
                ReduceStrengthEffect effect = player.EffectList.GetOfType(eEffectType.ReduceStrengthEffect) as ReduceStrengthEffect;

                if (effect == null)
                    player.AddEffect(new ReduceStrengthEffect(200, m_strengReduce), 0);//met
            }
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
