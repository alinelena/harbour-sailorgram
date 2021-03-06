// This file generated by libqtelegram-code-generator.
// You can download it from: https://github.com/Aseman-Land/libqtelegram-code-generator
// DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN

#ifndef LQTG_TYPE_PHOTO
#define LQTG_TYPE_PHOTO

#include "telegramtypeobject.h"
#include <QtGlobal>
#include "geopoint.h"
#include <QList>
#include "photosize.h"

class LIBQTELEGRAMSHARED_EXPORT Photo : public TelegramTypeObject
{
public:
    enum PhotoType {
        typePhotoEmpty = 0x2331b22d,
        typePhoto = 0xc3838076
    };

    Photo(PhotoType classType = typePhotoEmpty, InboundPkt *in = 0);
    Photo(InboundPkt *in);
    virtual ~Photo();

    void setAccessHash(qint64 accessHash);
    qint64 accessHash() const;

    void setDate(qint32 date);
    qint32 date() const;

    void setGeo(const GeoPoint &geo);
    GeoPoint geo() const;

    void setId(qint64 id);
    qint64 id() const;

    void setSizes(const QList<PhotoSize> &sizes);
    QList<PhotoSize> sizes() const;

    void setUserId(qint32 userId);
    qint32 userId() const;

    void setClassType(PhotoType classType);
    PhotoType classType() const;

    bool fetch(InboundPkt *in);
    bool push(OutboundPkt *out) const;

    bool operator ==(const Photo &b);

private:
    qint64 m_accessHash;
    qint32 m_date;
    GeoPoint m_geo;
    qint64 m_id;
    QList<PhotoSize> m_sizes;
    qint32 m_userId;
    PhotoType m_classType;
};

#endif // LQTG_TYPE_PHOTO
