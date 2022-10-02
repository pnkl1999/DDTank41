using System;
using System.Text;
using Game.Server.GameObjects;
using Game.Server.LittleGame;
using Game.Server.Packets;

namespace Game.Server.Commands.Handlers
{
    [ChatCommand("Таймеры", "Инфа по таймерам!", AccessLevel.GOD)]
    public class Timers : IChatCommand
    {
        public int CommandHandler(GamePlayer Player, string[] args)
        {
            var sb = new StringBuilder();
            foreach (var timer in Task.TaskScheduler.Instance.Timers)
            {
                sb.AppendLine($"TIMER: {timer.Key}");
                sb.AppendLine($"{timer.Value.Item1}");
                sb.AppendLine($"{timer.Value.Item2}");
                sb.AppendLine($"END: {timer.Key}");
            }
            Player.Out.SendMessage(eMessageType.ALERT, sb.ToString());
            Console.WriteLine(sb.ToString());
            return 1;
        }
    }
}