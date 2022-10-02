package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.model.LocalPlayer;
   import trainer.data.Step;
   
   public class SoulPropBar extends FightPropBar
   {
       
      
      private var _propDatas:Array;
      
      private var _back:DisplayObject;
      
      private var _msgShape:DisplayObject;
      
      private var _lockScreen:DisplayObject;
      
      public function SoulPropBar(param1:LocalPlayer)
      {
         super(param1);
      }
      
      override protected function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.prop.SoulBack");
         addChild(this._back);
         this._lockScreen = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.LockScreen");
         addChild(this._lockScreen);
         super.configUI();
      }
      
      override protected function addEvent() : void
      {
         _self.addEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         _self.addEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
      }
      
      override public function enter() : void
      {
         this.setProps();
         this.updatePropByPsychic();
         super.enter();
      }
      
      private function __psychicChanged(param1:LivingEvent) : void
      {
         if(_enabled)
         {
            this.updatePropByPsychic();
         }
      }
      
      private function showHelpMsg() : void
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GHOST_FIRST) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GHOSTPROP_FIRST))
         {
            if(this._msgShape == null)
            {
               this._msgShape = ComponentFactory.Instance.creatBitmap("asset.game.ghost.msg2");
               this._msgShape.y = -this._msgShape.height;
               addChild(this._msgShape);
            }
            SocketManager.Instance.out.syncWeakStep(Step.GHOSTPROP_FIRST);
         }
      }
      
      private function updatePropByPsychic() : void
      {
         var _loc1_:PropCell = null;
         for each(_loc1_ in _cells)
         {
            if(_loc1_.info != null && _self.psychic >= _loc1_.info.needPsychic)
            {
               _loc1_.enabled = true;
               this.showHelpMsg();
            }
            else
            {
               _loc1_.enabled = false;
            }
         }
      }
      
      override protected function drawCells() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:SoulPropCell = null;
         var _loc1_:int = 0;
         var _loc4_:Point = new Point(4,4);
         while(_loc1_ < 20)
         {
            _loc5_ = new SoulPropCell();
            _loc5_.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            _loc2_ = _loc1_ % 10 * (_loc5_.width + 1);
            if(_loc1_ >= 10)
            {
               _loc3_ = _loc5_.height + 2;
            }
            _loc5_.setPossiton(_loc2_ + _loc4_.x,_loc3_ + _loc4_.y);
            addChild(_loc5_);
            _cells.push(_loc5_);
            _loc1_++;
         }
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc2_:PropCell = null;
         var _loc3_:String = null;
         if(_enabled)
         {
            if(this._msgShape)
            {
               ObjectUtils.disposeObject(this._msgShape);
               this._msgShape = null;
            }
            _loc2_ = param1.currentTarget as PropCell;
            SoundManager.instance.play("008");
            _loc3_ = _self.useProp(_loc2_.info,1);
            if(_loc3_ != UsePropErrorCode.Done && _loc3_ != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc3_));
            }
            super.__itemClicked(param1);
         }
      }
      
      public function setProps() : void
      {
         var _loc2_:PropInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._propDatas.length)
         {
            _loc2_ = new PropInfo(ItemManager.Instance.getTemplateById(this._propDatas[_loc1_]));
            _loc2_.Place = -1;
            _cells[_loc1_].info = _loc2_;
            _loc1_++;
         }
      }
      
      public function set props(param1:String) : void
      {
         this._propDatas = param1.split(",");
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._lockScreen);
         this._lockScreen = null;
      }
   }
}
