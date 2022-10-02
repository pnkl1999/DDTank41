package room.view.chooseMap
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DungeonMapItem extends BaseMapItem
   {
      
      private static const SHINE_DELAY:int = 200;
       
      
      private var _timer:Timer;
      
      private var _gainReduce:Bitmap;
      
      public function DungeonMapItem()
      {
         super();
         this._timer = new Timer(SHINE_DELAY);
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._gainReduce = ComponentFactory.Instance.creatBitmap("asset.room.view.item.gainReduce");
         this._gainReduce.visible = false;
         addChild(this._gainReduce);
      }
      
      public function shine() : void
      {
         this._timer.start();
      }
      
      public function stopShine() : void
      {
         this._timer.stop();
         !!this._timer.reset();
         _selectedBg.visible = _selected;
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         _selectedBg.visible = this._timer.currentCount % 2 == 1;
      }
      
      override public function set mapId(param1:int) : void
      {
         _mapId = param1;
         this.updateMapIcon();
         buttonMode = mapId == -1 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      override protected function updateMapIcon() : void
      {
         var _loc1_:Object = PlayerManager.Instance.Self.dungeonFlag;
         if(_loc1_ && _loc1_[_mapId] == 0)
         {
            this._gainReduce.visible = true;
         }
         else
         {
            this._gainReduce.visible = false;
         }
         if(_mapId == -1)
         {
            ObjectUtils.disposeAllChildren(_mapIconContaioner);
            return;
         }
         super.updateMapIcon();
      }
      
      override public function dispose() : void
      {
         this.stopShine();
         super.dispose();
      }
   }
}
