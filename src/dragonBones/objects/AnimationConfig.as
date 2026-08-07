package dragonBones.objects
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.animation.AnimationFadeOutMode;
   import dragonBones.core.BaseObject;
   
   public final class AnimationConfig extends BaseObject
   {
      
      public var pauseFadeOut:Boolean;
      
      public var fadeOutMode:int;
      
      public var fadeOutTime:Number;
      
      public var fadeOutEasing:Number;
      
      public var additiveBlending:Boolean;
      
      public var displayControl:Boolean;
      
      public var pauseFadeIn:Boolean;
      
      public var actionEnabled:Boolean;
      
      public var playTimes:int;
      
      public var layer:int;
      
      public var position:Number;
      
      public var duration:Number;
      
      public var timeScale:Number;
      
      public var fadeInTime:Number;
      
      public var autoFadeOutTime:Number;
      
      public var fadeInEasing:Number;
      
      public var weight:Number;
      
      public var name:String;
      
      public var animationName:String;
      
      public var group:String;
      
      public const boneMask:Vector.<String> = new Vector.<String>();
      
      public function AnimationConfig()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         this.pauseFadeOut = true;
         this.fadeOutMode = AnimationFadeOutMode.All;
         this.fadeOutTime = -1;
         this.fadeOutEasing = 0;
         this.additiveBlending = false;
         this.displayControl = true;
         this.pauseFadeIn = true;
         this.actionEnabled = true;
         this.playTimes = -1;
         this.layer = 0;
         this.position = 0;
         this.duration = -1;
         this.timeScale = -100;
         this.fadeInTime = -1;
         this.autoFadeOutTime = -1;
         this.fadeInEasing = 0;
         this.weight = 1;
         this.name = null;
         this.animationName = null;
         this.group = null;
         this.boneMask.length = 0;
      }
      
      public function clear() : void
      {
         this._onClear();
      }
      
      public function copyFrom(param1:AnimationConfig) : void
      {
         this.pauseFadeOut = param1.pauseFadeOut;
         this.fadeOutMode = param1.fadeOutMode;
         this.autoFadeOutTime = param1.autoFadeOutTime;
         this.fadeOutEasing = param1.fadeOutEasing;
         this.additiveBlending = param1.additiveBlending;
         this.displayControl = param1.displayControl;
         this.pauseFadeIn = param1.pauseFadeIn;
         this.actionEnabled = param1.actionEnabled;
         this.playTimes = param1.playTimes;
         this.layer = param1.layer;
         this.position = param1.position;
         this.duration = param1.duration;
         this.timeScale = param1.timeScale;
         this.fadeInTime = param1.fadeInTime;
         this.fadeOutTime = param1.fadeOutTime;
         this.fadeInEasing = param1.fadeInEasing;
         this.weight = param1.weight;
         this.name = param1.name;
         this.animationName = param1.animationName;
         this.group = param1.group;
         this.boneMask.length = param1.boneMask.length;
         var _loc2_:uint = 0;
         var _loc3_:uint = this.boneMask.length;
         while(_loc2_ < _loc3_)
         {
            this.boneMask[_loc2_] = param1.boneMask[_loc2_];
            _loc2_++;
         }
      }
      
      public function containsBoneMask(param1:String) : Boolean
      {
         return this.boneMask.length === 0 || this.boneMask.indexOf(param1) >= 0;
      }
      
      public function addBoneMask(param1:Armature, param2:String, param3:Boolean = true) : void
      {
         var _loc5_:Vector.<Bone> = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Bone = null;
         var _loc4_:Bone = param1.getBone(param2);
         if(!_loc4_)
         {
            return;
         }
         if(this.boneMask.indexOf(param2) < 0)
         {
            this.boneMask.push(param2);
         }
         if(param3)
         {
            _loc5_ = param1.getBones();
            _loc6_ = 0;
            _loc7_ = _loc5_.length;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc5_[_loc6_];
               if(this.boneMask.indexOf(_loc8_.name) < 0 && _loc4_.contains(_loc8_))
               {
                  this.boneMask.push(_loc8_.name);
               }
               _loc6_++;
            }
         }
      }
      
      public function removeBoneMask(param1:Armature, param2:String, param3:Boolean = true) : void
      {
         var _loc5_:Bone = null;
         var _loc6_:Vector.<Bone> = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Bone = null;
         var _loc4_:int = int(this.boneMask.indexOf(param2));
         if(_loc4_ >= 0)
         {
            this.boneMask.splice(_loc4_,1);
         }
         if(param3)
         {
            _loc5_ = param1.getBone(param2);
            if(_loc5_)
            {
               _loc6_ = param1.getBones();
               if(this.boneMask.length > 0)
               {
                  _loc7_ = 0;
                  _loc8_ = _loc6_.length;
                  while(_loc7_ < _loc8_)
                  {
                     _loc9_ = _loc6_[_loc7_];
                     _loc4_ = int(this.boneMask.indexOf(_loc9_.name));
                     if(_loc4_ >= 0 && _loc5_.contains(_loc9_))
                     {
                        this.boneMask.splice(_loc4_,1);
                     }
                     _loc7_++;
                  }
               }
               else
               {
                  _loc7_ = 0;
                  _loc8_ = _loc6_.length;
                  while(_loc7_ < _loc8_)
                  {
                     _loc9_ = _loc6_[_loc7_];
                     if(!_loc5_.contains(_loc9_))
                     {
                        this.boneMask.push(_loc9_.name);
                     }
                     _loc7_++;
                  }
               }
            }
         }
      }
   }
}

