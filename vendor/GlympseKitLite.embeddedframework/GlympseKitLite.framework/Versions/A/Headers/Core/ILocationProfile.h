//------------------------------------------------------------------------------
//
// Copyright (c) 2012 Glympse Inc.  All rights reserved.
//
//------------------------------------------------------------------------------

#ifndef ILOCATIONPROFILE_H__GLYMPSE__
#define ILOCATIONPROFILE_H__GLYMPSE__

namespace Glympse
{

/**
 * Location profile defines configuration of location provider, that should be applied
 * at given moment of time. Location profiles are used to provide host application with a chance
 * to tune location provider behavior based on library state to minimize battery consumption.
 *
 * Location provider can either access profile properties or apply configuration based
 * on profile ID (see getProfile()).
 *
 * Location profiles are immutable. Profile can be created using one of CoreFactory#createProfile()
 * methods. Profiles are applied using ILocationManager#updateProfile().
 */
/*O*public**/ struct ILocationProfile : public IComparable
{
    /**
     * Profile identifier.
     *
     * This can be one of CC::LOCATION_PROFILE_* values.
     */
    public: virtual int32 getProfile() = 0;
    
    /**
     * Post rate defines interval between calls to server.
     *
     * - Platform:   Common
     * - Type:       int32
     * - Values: 
     *   - Not set = 0
     *   - Time in milliseconds
     */
    public: virtual int32 getPostRate() = 0;

    /**
     * Indicates whether location provider should be started at all, when provider is applied. 
     * CC::LOCATION_MODE_DEFAULT should be used in most cases. 
     *
     *  - Platform:    Android
     * - Version:     Level 1+
     * - Type:        int32
     * - Values:      One of CC::LOCATION_MODE_* values.
     */
    public: virtual int32 getMode() = 0;
    
    /**
     * Specifies, which exact source(s) should be used to query location data. 
     * 
     * - Platform:    Android
     * - Version:     Level 1+
     * - Type:        int32 (bitmask)
     * - Values:      A combination of any of CC::LOCATION_SOURCE_* values.
     */
    public: virtual int32 getSource() = 0;
    
    /**
     * Minimum distance between location updates.
     *
     * - Platform:    Common
     * - Type:        double
     * - Values (iOS):
     *   -   kCLDistanceFilterNone                = -1
     *   -   Distance in meters
     * - Applied to (iOS):      CLLocationManager.distanceFilter
     * - Values (Android):
     *   -   BEST                                 = 0
     *   -   Distance in meters
     * - Applied to (Android):  LocationManager.requestLocationUpdates(..., float minDistance, ...)
     */
    public: virtual double getDistance() = 0;

    /**
     * The accuracy of the location data.
     *
     * - Platform:    iOS
     * - Version:     2.0+
     * - Type:        CLLocationAccuracy
     * - Applied to:  CLLocationManager.desiredAccuracy
     * - Values (iOS):
     *   -   kCLLocationAccuracyBestForNavigation = -2
     *   -   kCLLocationAccuracyBest              = -1
     *   -   Distance in meters [0..3000]
     */
    public: virtual double getAccuracy() = 0;
    
    /**
     * Minimum time interval between location updates.
     *
     * - Platform:    Android
     * - Version:     Level 1+
     * - Type:        int32
     * - Applied to:  LocationManager.requestLocationUpdates(long minTime, ...)
     * - Values:
     *   -   BEST                                 = 0
     *   -   Time in milliseconds
     */
    public: virtual int32 getFrequency() = 0;
    
    /**
     * The type of user activity associated with the location updates.
     *
     * Platform:    iOS
     * Version:     6.0+
     * Type:        CLActivityType
     * Applied to:  CLLocationManager.activityType     
     * Values:
     *     CLActivityTypeOther                  = 1  (default)
     *     CLActivityTypeAutomotiveNavigation   = 2
     *     CLActivityTypeFitness                = 3
     *     CLActivityTypeOtherNavigation        = 4
     */
    public: virtual int32 getActivity() = 0;
    
    /**
     * A bool value indicating whether the location provider object may pause location updates.
     *
     * - Platform:    iOS
     * - Version:     6.0+
     * - Type:        bool
     * - Applied to:  LocationManager.pausesLocationUpdatesAutomatically
     * - Values:      true/false
     */
    public: virtual bool isAutoPauseEnabled() = 0;
};
    
/*C*/typedef O< ILocationProfile > GLocationProfile;/**/
    
}

#endif // !ILOCATIONPROFILE_H__GLYMPSE__
