package com.pickgliss.ui
{
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public final class ComponentFactory
   {
      
      private static var _instance:ComponentFactory;
      
      private static var COMPONENT_COUNTER:int = 1;
       
      
      private var _allComponents:Dictionary;
      
      private var _model:ComponentModel;
      
      public function ComponentFactory(param1:ComponentFactoryEnforcer)
      {
         super();
         this._model = new ComponentModel();
         this._allComponents = new Dictionary();
         ClassUtils.uiSourceDomain = ApplicationDomain.currentDomain;
      }
      
      public static function get Instance() : ComponentFactory
      {
         if(_instance == null)
         {
            _instance = new ComponentFactory(new ComponentFactoryEnforcer());
         }
         return _instance;
      }
      
      public static function parasArgs(param1:String) : Array
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            StringUtils.trim(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function creat(param1:String, param2:Array = null) : *
      {
         var _loc3_:* = undefined;
         if(this._model.getComonentStyle(param1))
         {
            _loc3_ = this.creatComponentByStylename(param1);
         }
         else if(this._model.getBitmapSet(param1) || ClassUtils.classIsBitmapData(param1))
         {
            _loc3_ = this.creatBitmap(param1);
         }
         else if(this._model.getCustomObjectStyle(param1))
         {
            _loc3_ = this.creatCustomObject(param1,param2);
         }
         else
         {
            _loc3_ = ClassUtils.CreatInstance(param1,param2);
         }
         return _loc3_;
      }
      
      public function creatBitmap(param1:String) : Bitmap
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         var _loc2_:XML = this._model.getBitmapSet(param1);
         if(_loc2_ == null)
         {
            if(!ClassUtils.uiSourceDomain.hasDefinition(param1))
            {
               throw new Error("Bitmap:" + param1 + " is Not Found!",888);
            }
            _loc3_ = ClassUtils.CreatInstance(param1,[0,0]);
            _loc4_ = new Bitmap(_loc3_);
            this._model.addBitmapSet(param1,new XML("<bitmapData resourceLink=\'" + param1 + "\' width=\'" + _loc4_.width + "\' height=\'" + _loc4_.height + "\' />"));
         }
         else
         {
            if(_loc2_.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
            {
               _loc3_ = this.creatBitmapData(param1);
               _loc4_ = new Bitmap(_loc3_,"auto",String(_loc2_.@smoothing) == "true");
            }
            else
            {
               _loc4_ = ClassUtils.CreatInstance(param1);
            }
            ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_);
         }
         return _loc4_;
      }
      
      public function creatBitmapData(param1:String) : BitmapData
      {
         var _loc3_:BitmapData = null;
         var _loc2_:XML = this._model.getBitmapSet(param1);
         if(_loc2_ == null)
         {
            return ClassUtils.CreatInstance(param1,[0,0]);
         }
         if(_loc2_.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
         {
            _loc3_ = ClassUtils.CreatInstance(param1,[int(_loc2_.@width),int(_loc2_.@height)]);
         }
         else
         {
            _loc3_ = ClassUtils.CreatInstance(param1)["btimapData"];
         }
         return _loc3_;
      }
      
      public function creatComponentByStylename(param1:String, param2:Array = null) : *
      {
         var _loc3_:XML = this.getComponentStyle(param1);
         var _loc4_:String = _loc3_.@classname;
         var _loc5_:* = ClassUtils.CreatInstance(_loc4_,param2);
         _loc5_.id = this.componentID;
         this._allComponents[_loc5_.id] = _loc5_;
         if(ClassUtils.classIsComponent(_loc4_))
         {
            _loc5_.beginChanges();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_);
            _loc5_.commitChanges();
         }
         else
         {
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_);
         }
         _loc5_["stylename"] = param1;
         return _loc5_;
      }
      
      private function getComponentStyle(param1:String) : XML
      {
         var _loc3_:XML = null;
         var _loc2_:XML = this._model.getComonentStyle(param1);
         while(_loc2_.hasOwnProperty("@parentStyle"))
         {
            _loc3_ = this._model.getComonentStyle(String(_loc2_.@parentStyle));
            delete _loc2_.@parentStyle;
            ObjectUtils.combineXML(_loc2_,_loc3_);
         }
         return _loc2_;
      }
      
      public function getCustomStyle(param1:String) : XML
      {
         var _loc3_:XML = null;
         var _loc2_:XML = this._model.getCustomObjectStyle(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         while(_loc2_ && _loc2_.hasOwnProperty("@parentStyle"))
         {
            _loc3_ = this._model.getCustomObjectStyle(String(_loc2_.@parentStyle));
            delete _loc2_.@parentStyle;
            ObjectUtils.combineXML(_loc2_,_loc3_);
         }
         return _loc2_;
      }
      
      public function creatCustomObject(param1:String, param2:Array = null) : *
      {
         var _loc3_:XML = this.getCustomStyle(param1);
         var _loc4_:String = _loc3_.@classname;
         var _loc5_:* = ClassUtils.CreatInstance(_loc4_,param2);
         ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_);
         return _loc5_;
      }
      
      public function getComponentByID(param1:int) : *
      {
         return this._allComponents[param1];
      }
      
      public function checkAllComponentDispose(param1:Array) : void
      {
         var _loc6_:XML = null;
         var _loc7_:* = undefined;
         var _loc2_:Dictionary = this._model.allComponentStyle;
         var _loc3_:int = param1.length;
         var _loc4_:int = 1;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_.@componentModule != null && _loc6_.@componentModule == param1[_loc5_])
               {
                  for each(_loc7_ in this._allComponents)
                  {
                     if(_loc7_ && _loc7_.stylename == _loc6_.@stylename)
                     {
                        _loc4_++;
                     }
                  }
               }
            }
            _loc5_++;
         }
      }
      
      public function removeComponent(param1:int) : void
      {
         delete this._allComponents[param1];
      }
      
      public function creatFrameFilters(param1:String) : Array
      {
         var _loc2_:Array = parasArgs(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_] == "null")
            {
               _loc3_.push(null);
            }
            else
            {
               _loc3_.push(this.creatFilters(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function creatFilters(param1:String) : Array
      {
         var _loc2_:Array = param1.split("|");
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(ComponentFactory.Instance.model.getSet(_loc2_[_loc4_]));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function get model() : ComponentModel
      {
         return this._model;
      }
      
      public function setup(param1:XML) : void
      {
         this._model.addComponentSet(param1);
      }
      
      public function get componentID() : int
      {
         return COMPONENT_COUNTER++;
      }
   }
}

class ComponentFactoryEnforcer
{
    
   
   function ComponentFactoryEnforcer()
   {
      super();
   }
}
