package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.FightPropEevnt;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.LocalPlayer;
   import game.view.control.FightControlBar;
   import game.view.control.SoulState;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class CustomPropBar extends FightPropBar
   {
       
      
      private var _selfInfo:SelfInfo;
      
      private var _type:int;
      
      private var _backStyle:String;
      
      private var _localVisible:Boolean = true;
      
      public function CustomPropBar(param1:LocalPlayer, param2:int)
      {
         this._selfInfo = param1.playerInfo as SelfInfo;
         this._type = param2;
         super(param1);
      }
      
      override protected function addEvent() : void
      {
         var _loc1_:PropCell = null;
         this._selfInfo.FightBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
         _self.addEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         for each(_loc1_ in _cells)
         {
            _loc1_.addEventListener(FightPropEevnt.DELETEPROP,this.__deleteProp);
            _loc1_.addEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         if(this._type == FightControlBar.LIVE)
         {
            _self.addEventListener(LivingEvent.ENERGY_CHANGED,__energyChange);
         }
         _self.addEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __psychicChanged(param1:LivingEvent) : void
      {
         if(_enabled)
         {
            this.updatePropByPsychic();
         }
      }
      
      private function updatePropByPsychic() : void
      {
         var _loc1_:PropCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.enabled = _loc1_.info != null && _self.psychic >= _loc1_.info.needPsychic;
         }
      }
      
      override protected function __enabledChanged(param1:LivingEvent) : void
      {
         this.enabled = _self.propEnabled && _self.customPropEnabled;
      }
      
      private function __customEnabledChanged(param1:LivingEvent) : void
      {
         this.enabled = _self.customPropEnabled;
      }
      
      private function __deleteProp(param1:FightPropEevnt) : void
      {
         var _loc2_:PropCell = param1.currentTarget as PropCell;
         GameInSocketOut.sendThrowProp(_loc2_.info.Place);
         SoundManager.instance.play("008");
         StageReferance.stage.focus = null;
      }
      
      private function __updateProp(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:PropInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = this._selfInfo.FightBag.getItemAt(_loc3_.Place);
            if(_loc4_)
            {
               _loc5_ = new PropInfo(_loc4_);
               _loc5_.Place = _loc4_.Place;
               _cells[_loc3_.Place].info = _loc5_;
            }
            else
            {
               _cells[_loc3_.Place].info = null;
            }
         }
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         this._selfInfo.FightBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
         _self.removeEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(FightPropEevnt.DELETEPROP,this.__deleteProp);
            _loc1_.removeEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         super.removeEvent();
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc2_:CustomPropCell = new CustomPropCell("z",_mode,this._type);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosz");
         _loc2_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc2_);
         var _loc3_:CustomPropCell = new CustomPropCell("x",_mode,this._type);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosx");
         _loc3_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc3_);
         var _loc4_:CustomPropCell = new CustomPropCell("c",_mode,this._type);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosc");
         _loc4_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc4_);
         _cells.push(_loc2_);
         _cells.push(_loc3_);
         _cells.push(_loc4_);
         drawLayer();
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_X.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_C.getCode():
               _cells[2].useProp();
         }
      }
      
      private function __useProp(param1:FightPropEevnt) : void
      {
         var _loc2_:PropInfo = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(_enabled && this._localVisible)
         {
            _loc2_ = PropCell(param1.currentTarget).info;
            _loc3_ = _self.useProp(_loc2_,2);
            if(_loc3_ == UsePropErrorCode.Done)
            {
               _loc4_ = EquipType.hasPropAnimation(_loc2_.Template);
               if(_loc4_ != null)
               {
                  _self.playSkillMovie(_loc4_);
               }
            }
            else if(_loc3_ != UsePropErrorCode.Done && _loc3_ != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc3_));
            }
         }
      }
      
      override public function enter() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PropInfo = null;
         var _loc1_:BagInfo = this._selfInfo.FightBag;
         for each(_loc2_ in _loc1_.items)
         {
            _loc3_ = new PropInfo(_loc2_);
            _loc3_.Place = _loc2_.Place;
            _cells[_loc2_.Place].info = _loc3_;
         }
         this.enabled = _self.customPropEnabled;
         super.enter();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(parent is SoulState && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            param1 = false;
         }
         super.enabled = param1;
      }
      
      public function set backStyle(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._backStyle != param1)
         {
            this._backStyle = param1;
            _loc2_ = _background;
            _background = ComponentFactory.Instance.creat(this._backStyle);
            addChildAt(_background,0);
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._localVisible != param1)
         {
            this._localVisible = param1;
         }
      }
   }
}
