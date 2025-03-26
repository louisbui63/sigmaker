#pragma once
#define NOMINMAX
#include <cstdint>
#include <expected>
#include <format>
#include <sstream>
#include <string>
#include <vector>

#include "Plugin.h"
#include "Version.h"

// Signature types and structures
enum class SignatureType : uint32_t {
  IDA = 0,
  x64Dbg,
  Signature_Mask,
  SignatureByteArray_Bitmask
};

typedef struct {
  uint8_t value;
  bool isWildcard;
} SignatureByte;

using Signature = std::vector<SignatureByte>;
