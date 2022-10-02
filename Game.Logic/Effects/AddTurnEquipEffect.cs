using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.Effects
{
    public class AddTurnEquipEffect : BasePlayerEffect
    {
        private int m_count = 0;

        private int m_probability = 0;

        private int m_templateID = 0;

        public AddTurnEquipEffect(int count, int probability, int templateID)
            : base(eEffectType.AddTurnEquipEffect)
        {
            m_count = count;
            m_probability = probability;
            m_templateID = templateID;
        }

        public override bool Start(Living living)
        {
            AddTurnEquipEffect effect = living.EffectList.GetOfType(eEffectType.AddTurnEquipEffect) as AddTurnEquipEffect;
            if (effect != null)
            {
                effect.m_probability = ((m_probability > effect.m_probability) ? m_probability : effect.m_probability);
                return true;
            }
            return base.Start(living);
        }

        protected override void OnAttachedToPlayer(Player player)
        {
            player.PlayerShoot += ChangeProperty;
            player.AfterPlayerShooted += Player_AfterPlayerShooted;
            player.BeginSelfTurn += player_BeginNextTurn;
        }

        private void Player_AfterPlayerShooted(Player player)
        {
            if (IsTrigger)
            {
                player.IsAddQuipTurn = true;
                player.Delay = 0;//layer.DefaultDelay;
            }    
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerShoot -= ChangeProperty;
            player.AfterPlayerShooted -= Player_AfterPlayerShooted;
            player.BeginSelfTurn -= player_BeginNextTurn;
        }

        public void player_BeginNextTurn(Living living)
        {
            if (IsTrigger && living is Player)// && (living as Player).Config.IsAddTurn)
            {
                int energy = 0;
                switch (m_templateID)
                {
                    case 311112:
                        energy = 50;
                        break;
                    case 311129:
                        energy = 50;
                        break;
                    case 311212:
                        energy = 50;
                        break;
                    case 311229:
                        energy = 55;
                        break;
                    case 311312:
                        energy = 60;
                        break;
                    case 311329:
                        energy = 65;
                        break;
                    case 311412:
                        energy = 70;
                        break;
                    case 311429:
                        energy = 75;
                        break;
                    case 311512:
                        energy = 75;
                        break;
                    case 311529:
                        energy = 75;
                        break;
                }
                living.IsAddQuipTurn = false;
                (living as Player).Delay += (living as Player).Delay * this.m_count / 100;
                int maxEnergy = (living as Player).Energy;
                (living as Player).Energy = maxEnergy * energy / 100;
                IsTrigger = false;
            }
        }

        private void ChangeProperty(Player player)
        {
            if (!player.CurrentBall.IsSpecial() && rand.Next(100) < m_probability && player.AttackGemLimit == 0)
            {
                player.AttackGemLimit = 4;
                IsTrigger = true;
                player.EffectTrigger = true;
                player.Game.SendEquipEffect(player, LanguageMgr.GetTranslation("AttackEffect.Success"));
                player.Game.AddAction(new LivingSayAction(player, LanguageMgr.GetTranslation("AddTurnEquipEffect.msg"), 9, 0, 1000));
            }
        }
    }
}
