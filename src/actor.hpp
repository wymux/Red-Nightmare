#ifndef REDNIGHTMARE_ACTOR_HPP
#define REDNIGHTMARE_ACTOR_HPP
#include "animation.hpp"
#include "tz/core/containers/enum_field.hpp"

namespace game
{
	/// Describes immutable characteristics for a specific actor.
	enum class ActorFlag
	{
		/// Move around with WASD
		KeyboardControlled,
	};
	using ActorFlags = tz::EnumField<ActorFlag>;

	/// Describes internal actions being performed by an actor this fixed update.
	enum class ActorAction
	{
		/// Actor sprite should be horizontally flipped until the next fixed update.
		HorizontalFlip,
		/// Actor should move to the left using its base movement speed.
		MoveLeft,
		/// Actor should move to the right using its base movement speed.
		MoveRight,
		/// Actor should move downwards using its base movement speed.
		MoveDown,
		/// Actor should move upwards using its base movement speed.
		MoveUp
	};
	using ActorActions = tz::EnumField<ActorAction>;

	/// Describes the general appearance of the actor. Will be used to automatically select which animations will be suitable for use. This might be refactored into something better.
	enum class ActorSkin
	{
		/// Actor looks like the player from the old incarnations of Red Nightmare.
		PlayerClassic
	};

	enum class ActorType
	{
		/// A keyboard-controlled player using the classic skin.
		PlayerClassic
	};

	struct Actor
	{
		/// Describes the characteristics of the actor.
		ActorFlags flags = {};
		/// Base movement speed of the actor.
		float base_movement = 0.0f;
		/// Describes appearance of the actor.
		ActorSkin skin = {};
		/// Describes what the actor is upto for this fixed-update.
		ActorActions actions = {};
		/// The animation currently playing on the actor.
		Animation animation = play_animation(static_cast<AnimationID>(0));

		void update();
		static Actor null(){return {};}
		bool operator==(const Actor& rhs) const = default;
	private:
		/// Set the animation, but if we're already running that animation don't reset it.
		void assign_animation(AnimationID id);
	};

	Actor create_actor(ActorType type);
}

#endif // REDNIGHTMARE_ACTOR_HPP